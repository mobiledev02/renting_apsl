const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const database = admin.firestore();

// chat message notification...
exports.chatNotificationStaging = functions.firestore
    .document("staging_messages/{chatRoomId}/chats/{chatId}")
    .onCreate(async (messageSnapShot, context) => {
    functions.logger.log('function executes');
        const messageInfo = messageSnapShot.data();
        const receiverId = messageInfo["receiver_info"]["id"];
        const title = messageInfo["sender_info"]["name"];
        const body = messageInfo.message;

        console.log("PAY LOD ", messageInfo);

        // userId => Notification recevier user id.
        // Notification title => To get Title.
        // Notification body => To get body.
        // payload data => Data to be sent with notification.
        await createPushNotificationStaging(receiverId, title, body, toNotificationPayLoadInfo(title, body, messageInfo));
        return null;
    });

// userId => Notification recevier.
// Notification title => To get Title.
// Notification body => To get body.
// payload data => Data to be sent with notification.
createPushNotificationStaging = async function (
    userId,
    notificationTitle,
    notificationBody,
    payloadData
) {
    // Fetch user...
    const userInfoFuture = database
        .collection("staging_users")
        .where("id", "==", userId)
        .get();

    // Wait for response from promise...
    const userInfoPromise = await Promise.all([userInfoFuture]);


    //if token is avaialble...
    if (userInfoPromise[0].docs.length > 0) {
        var tokens = userInfoPromise[0].docs[0]
            .data()
        ["fcm_id_list"].map(function (item) {
            return item["fcm_id"];
        });

        // Check if token is avaialble...
        if (tokens.length > 0) {
            await sendNotification(
                tokens,
                notificationTitle,
                notificationBody,
                payloadData
            );
        }
    }
};

// Send notification for listed acitivity...(a message can transfer a payload of up to 4 KB to a client app).
async function sendNotification(
    fcmTokens,
    notificationTitle,
    notificationBody,
    payloadData
) {
    try {
        let title = notificationTitle ?? "";
        let body = notificationBody ?? "";

        // Notification payload...
        const payload = {
            notification: {
                title: title,
                body: body,
                badge: "1",
                sound: "default",
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
            data: payloadData,
        };

        // Send notification to multiple device at same time...
        const response = await admin.messaging().sendToDevice(fcmTokens, payload);
        // console.log("Successfully sent message:", response);
    } catch (error) {
        console.log("Error sending message:", error);
    }
}

// User info to set in all the other collections except [Users] collection...
// (Check otherCollectionuserInfo in usermodel in project it should be same)
//TODO: change the settings here and the structure of the messages
function toNotificationPayLoadInfo(title, name, userInfo) {
    return {
        chatRoomId: userInfo.chatRoomId,
        item_id: userInfo.item_id,
        id: userInfo.sender_info.id,
        name: userInfo.sender_info.name,
        notification_title: title,
        notification_body: name,
        lender_id: userInfo.lender_id,
        renter_id: userInfo.renter_id,
        isSingleChat: `${userInfo.forSingleChat}`
      //  isSingleChat: `${userInfo.isSingleChat}`
    };
}