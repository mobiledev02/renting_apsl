import 'dart:convert';
import 'package:ASL_Auth/ASL_Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:renting_app_mobile/models/categories_model.dart';
import 'package:renting_app_mobile/models/fcm_id_model.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import 'package:renting_app_mobile/models/location_model.dart';
import 'package:renting_app_mobile/models/review_model.dart';
import '../../constants/img_font_color_string.dart';
import '../api/api_end_points.dart';
import 'api_response_model.dart';
import '../utils/custom_extension.dart';
import '../utils/custom_enum.dart';

// UserInfo from stored json...
UserInfoModel userInfoFromStoredJson(String str) => str.isEmpty
    ? UserInfoModel(authType: AuthType.None)
    : UserInfoModel.fromJson(
        json.decode(str),
      );

// UserInfo from server json...
// user info model changed json model
UserInfoModel userInfoFromServerJson(String str) => UserInfoModel.fromJson(
      defaultRespInfo(str).resultObj,
    );

// UserInfo to raw json (Json to json string)...
String userInfoToRawJson(UserInfoModel userInfo) => json.encode(
      userInfo.toJson(),
    );

List<UserInfoModel> listOfUserInfoModelFromJson(
        List<Map<String, dynamic>> str) =>
    List<UserInfoModel>.from(str.map((x) => UserInfoModel.fromJson(x)));

class UserInfoModel {
  // User object keys...
  static const String _kId = "id";
  static const String _kName = "name";
  static const String _kEmail = "email";
  static const String _kChatId = 'chat_id';

  static const String _kStripeConnected = "account_connected";

  static const String _kFcMId = "fcm_id";
  static const String _kFcMIdList = "fcm_id_list";
  static const String _kDeviceId = "device_id";
  static const String _kToken = "token";
  static const String _kReferenceToken = "reference_token";
  static const String _kRole = "role";
  static const String _kPassword = "password";
  static const String _kUserDevice = "user_device";
  static const String _kCustomToken = "firebase_token";
  static const String _kInfo = "info";
  static const String _kLocation = "location_model";
  static const String _kProfileImage = "profile_image";
  static const String _kAddress = "address";
  static const String _kCity = "city";
  static const String _kState = "state";
  static const String _kCountry = "country";
  static const String _kPinCode = "pin_code";
  static const String _kLatitude = "latitude";
  static const String _kLongitude = "longitude";
  static const String _kStatus = "status";
  static const String _kTime = "time";
  static const String _kUnreadMessageCount = "unread_message_count";
  static const String _kPlaceId = "place_id";
  static const String _kTotalBalance = "total_balance";
  static const String _kItemDetail = "item_detail";
  static const String _kPushNotification = "push_notification";
  static const String _kEmailNotification = "email_notification";
  static const String _kToggleStripe = "toggle_stripe";
  static const String _kTimeZone = "timezone";
  static const String _kChatRoomId = "chatRoomId";
  static const String _kPhone = "phone";
  static const String _kOTP = "otp";
  static const String _kReviews = 'reviews';
  static const String _kVerified = 'is_verified';
  static const String _kVerificationSubmitted = 'verification_status';
  static const String _kNewPassword = 'new_password';

  String id;
  String name,
      email,
      password,
      token,
      referenceToken,
      chattingWith = "",
      customToken,
      profileImage = "",
      address,
      info,
      placeId,
      totalBalance,
      status,
      timeZone,
      chatRoomId,
      chatId,
      phone,
      otp;

  double latitude, longitude;
  int? jobsDone;
  bool stripeConnected;
  String? verified;
  String? verificationSubmitted;
  String? lastMessage;
  String? chatStatus;
  int unreadMessageCount = 0, time = 0;
  ItemDetailModel? itemDetailModel;
  AuthType authType;
  String locationModel;
  DateTime? chatCreatedDate;
  List<String>? userPhotoIdForDelete;
  UserDevice? userDevice = UserDevice();
  List<FcmIdModel> fcmIdModel;
  List<ReviewModel>? reviews = [];
  String? newPassword;

  UserInfoModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.locationModel = "",
    this.token = "",
    this.jobsDone,
    this.reviews,
    this.stripeConnected = false,
    this.verified,
    this.verificationSubmitted,
    this.phone = "",
    this.otp = "",
    required this.authType,
    this.password = "",
    this.referenceToken = "",
    this.customToken = "",
    this.userPhotoIdForDelete,
    this.chattingWith = "",
    this.unreadMessageCount = 0,
    this.profileImage = "",
    this.userDevice,
    this.address = "",
    this.info = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.status = "",
    this.placeId = "",
    this.chatCreatedDate,
    this.lastMessage,
    this.chatStatus,
    this.totalBalance = "",
    this.itemDetailModel,
    this.time = 0,
    this.timeZone = "",
    this.chatRoomId = "",
    this.chatId = "",
    this.fcmIdModel = const [],
    this.newPassword = "",
  });

  factory UserInfoModel.fromJson(Map<dynamic, dynamic> json) {
    //  debugPrint('got the string ${json[_kStripeConnected]} $json');
    return UserInfoModel(
      id: json[_kId].toString(),
      email: json[_kEmail] ?? "",
      name: json[_kName] ?? "",
      token: json[_kToken] ?? "",
      stripeConnected: json[_kStripeConnected] == 1 ? true : false,
      authType: AuthType.None,
      profileImage: json[_kProfileImage] ?? "",
      referenceToken: json[_kReferenceToken] ?? "",
      customToken: json[_kCustomToken] ?? "",
      verified: json[_kVerified],
      verificationSubmitted: json[_kVerificationSubmitted],
      chattingWith: json[StaticString.chattingWith] ?? "",
      unreadMessageCount: json[StaticString.unreadMessageCount] ?? 0,
      userDevice: json["user_device"] == null
          ? null
          : UserDevice.fromJson(
              json["user_device"],
            ),
      address: json[_kAddress] ?? "",
      phone: json[_kPhone] ?? " ",
      info: json[_kInfo] ?? "",
      latitude: json[_kLatitude] ?? 0.0,
      longitude: json[_kLongitude] ?? 0.0,
      status: json[_kStatus] != null ? json[_kStatus].toString() : "",
      totalBalance: json[_kTotalBalance] ?? "0.00",
      time: json[_kTime] ?? 0,
      timeZone: json[_kTimeZone] ?? "",
      chatRoomId: json[_kChatRoomId] ?? "",
      chatId: json[_kChatId] ?? "",
      chatCreatedDate: json['chat_created_at'] != null
          ? json['chat_created_at'].toDate()
          : null,
      lastMessage: json['last_message'] ?? "",
      chatStatus: json['chat_status'] ?? "Pending",

      fcmIdModel: List<FcmIdModel>.from(
        (json["fcm_id_list"] ?? []).map(
          (x) => FcmIdModel.fromJson(x),
        ),
      ),
      //  reviews: parseReviews(json[_kReviews] ?? []),
    );
  }

  factory UserInfoModel.fromJson2(Map<dynamic, dynamic> json) {
    //  debugPrint('got the string ${json[_kStripeConnected]} $json');
    return UserInfoModel(
      id: json[_kId].toString(),
      email: json[_kEmail] ?? "",
      name: json[_kName] ?? "",
      token: json[_kToken] ?? "",
      stripeConnected: json[_kStripeConnected] == 1 ? true : false,
      authType: AuthType.None,
      profileImage: json[_kProfileImage] ?? "",
      referenceToken: json[_kReferenceToken] ?? "",
      customToken: json[_kCustomToken] ?? "",
      verified: json[_kVerified],
      verificationSubmitted: json[_kVerificationSubmitted],
      chattingWith: json[StaticString.chattingWith] ?? "",
      unreadMessageCount: json[StaticString.unreadMessageCount] ?? 0,
      userDevice: json["user_device"] == null
          ? null
          : UserDevice.fromJson(
        json["user_device"],
      ),
      address: json[_kAddress] ?? "",
      phone: json[_kPhone] ?? " ",
      info: json[_kInfo] ?? "",
      latitude: json[_kLatitude] ?? 0.0,
      longitude: json[_kLongitude] ?? 0.0,
      status: json[_kStatus] != null ? json[_kStatus].toString() : "",
      totalBalance: json[_kTotalBalance] ?? "0.00",
      time: json[_kTime] ?? 0,
      timeZone: json[_kTimeZone] ?? "",
      chatRoomId: json[_kChatRoomId] ?? "",
      chatId: json[_kChatId] ?? "",

      // attach chat attributes separately in this section
    );
  }

  factory UserInfoModel.fromJsonWithReviews(
      Map<dynamic, dynamic> json, List rJson) {
    debugPrint('got the string ${json['jobs_done']} $json');
    return UserInfoModel(
      id: json[_kId].toString(),
      email: json[_kEmail] ?? "",
      name: json[_kName] ?? "",
      token: json[_kToken] ?? "",
      stripeConnected: json[_kStripeConnected] == 1 ? true : false,
      verified: json[_kVerified],
      verificationSubmitted: json[_kVerificationSubmitted],
      authType: AuthType.None,
      profileImage: json[_kProfileImage] ?? "",
      referenceToken: json[_kReferenceToken] ?? "",
      customToken: json[_kCustomToken] ?? "",
      chattingWith: json[StaticString.chattingWith] ?? "",
      unreadMessageCount: json[StaticString.unreadMessageCount] ?? 0,
      userDevice: json["user_device"] == null
          ? null
          : UserDevice.fromJson(
              json["user_device"],
            ),
      address: json[_kAddress] ?? "",
      phone: json[_kPhone] ?? " ",
      info: json[_kInfo] ?? "",
      latitude: json[_kLatitude] ?? 0.0,
      longitude: json[_kLongitude] ?? 0.0,
      status: json[_kStatus] != null ? json[_kStatus].toString() : "",
      totalBalance: json[_kTotalBalance] ?? "0.00",
      time: json[_kTime] ?? 0,
      timeZone: json[_kTimeZone] ?? "",
      jobsDone: int.tryParse(json['jobs_done'].toString()) ?? 0,
      chatRoomId: json[_kChatRoomId] ?? "",
      chatId: json[_kChatId] ?? "",
      fcmIdModel: List<FcmIdModel>.from(
        (json["fcm_id_list"] ?? []).map(
          (x) => FcmIdModel.fromJson(x),
        ),
      ),
      reviews: parseReviews(rJson),
    );
  }

  factory UserInfoModel.fromJsonReviewerProfile(Map<dynamic, dynamic> json) {
    //  debugPrint('got the string ${json[_kStripeConnected]} $json');
    return UserInfoModel(
      id: json[_kId].toString(),
      email: json[_kEmail] ?? "",
      name: json[_kName] ?? "",
      token: json[_kToken] ?? "",
      stripeConnected: json[_kStripeConnected] == 1 ? true : false,
      authType: AuthType.None,
      profileImage: json['profile_image_url'] ?? "",
      verified: json[_kVerified],
      verificationSubmitted: json[_kVerificationSubmitted],
      referenceToken: json[_kReferenceToken] ?? "",
      customToken: json[_kCustomToken] ?? "",
      chattingWith: json[StaticString.chattingWith] ?? "",
      unreadMessageCount: json[StaticString.unreadMessageCount] ?? 0,
      userDevice: json["user_device"] == null
          ? null
          : UserDevice.fromJson(
              json["user_device"],
            ),
      address: json[_kAddress] ?? "",
      phone: json[_kPhone] ?? " ",
      info: json[_kInfo] ?? "",
      latitude: json[_kLatitude] ?? 0.0,
      longitude: json[_kLongitude] ?? 0.0,
      status: json[_kStatus] != null ? json[_kStatus].toString() : "",
      totalBalance: json[_kTotalBalance] ?? "0.00",
      time: json[_kTime] ?? 0,
      timeZone: json[_kTimeZone] ?? "",
      chatRoomId: json[_kChatRoomId] ?? "",
      chatId: json[_kChatId] ?? "",
      fcmIdModel: List<FcmIdModel>.from(
        (json["fcm_id_list"] ?? []).map(
          (x) => FcmIdModel.fromJson(x),
        ),
      ),
      //   reviews: parseReviews(rJson),
    );
  }

  // To cloned data...
  UserInfoModel get toClonedInfo => UserInfoModel.fromJson(this.toJson());

  String get getBearerToken {
    return "Bearer" + " " + token;
  }

  static List<ReviewModel>? parseReviews(List json) {
    try {
      final List<ReviewModel> reviews =
          json.map((e) => ReviewModel.fromJson(e)).toList();
      return reviews;
    } catch (e, st) {
      debugPrint('parseReviews $e $st');
      return [];
    }
  }

  // API Request Info (Set parameters and Request type according to your Postman API collection)...
  APIRequestInfoObj toAPIRequestInfo() {
    Map<String, dynamic> _params = {};
    HTTPRequestType requestType = HTTPRequestType.POST;
    List<UploadDocumentObj> docList = [];

    switch (this.authType) {
      case AuthType.Login:
        _params = this.toLoginJson();
        // print(_params);
        break;

      case AuthType.SignUp:
        _params = this.toSignUpJson();
        // print(_params);
        docList = profileImage.isEmpty
            ? []
            : [
                UploadDocumentObj(
                  docKey: _kProfileImage,
                  docPathList: [profileImage],
                ),
              ];
        print(" - - - DOCUMENT LIST - - - : $docList");
        break;

      case AuthType.ForgotPassword:
        _params = this.toForgotPasswordJson();
        break;

      case AuthType.ChangePassword:
        _params = this.toChangePassword();
        break;

      case AuthType.UpdateProfile:
        _params = this.toUpdateProfileJson();
        docList = profileImage.isEmpty
            ? []
            : [
                UploadDocumentObj(
                  docKey: _kProfileImage,
                  docPathList: [profileImage],
                ),
              ];
        break;

      case AuthType.SetFcmToken:
        break;

      case AuthType.OTP:
        _params = toOTPJson();
        break;
      case AuthType.resentOTP:
        _params = toResendOTPJson();
        break;
      case AuthType.TermsAndCondition:
        break;

      case AuthType.PrivacyPolicy:
        break;

      case AuthType.DeleteAccount:
        requestType = HTTPRequestType.DELETE;

        break;

      case AuthType.Logout:
        _params = this.toLogoutJson();
        break;

      case AuthType.None:
        break;
    }

    return APIRequestInfoObj(
      requestType: requestType,
      url: EndPoints.auth.authEndpoint(this),
      parameter: _params,
      docList: docList,
    );
  }

  Map<String, dynamic> toJson() => {
        _kId: id,
        _kEmail: email,
        _kName: name,
        _kAddress: address,
        _kLatitude: latitude,
        _kLongitude: longitude,
        _kInfo: info,
        _kState: status,
        _kToken: token,
        _kStripeConnected: stripeConnected,
        _kReferenceToken: referenceToken,
        _kProfileImage: profileImage,
        _kCustomToken: customToken,
        StaticString.chattingWith: chattingWith,
        StaticString.unreadMessageCount: unreadMessageCount,
        _kUserDevice: userDevice?.toJson(),
        _kItemDetail: itemDetailModel?.toFirebaseCreateLendJson(),
        _kReviews: encodedReviews(),
        _kChatId: chatId,
      };

  String encodedReviews() {
    try {
      return json.encode(reviews);
    } catch (e, st) {
      debugPrint('encodingReviews $e $st');
      return '';
    }
  }

  Map<String, dynamic> toMessageJson() => {
        _kId: id,
        _kEmail: email,
        _kName: name,
      };

  Map<String, dynamic> tolenderInfoJson() => {
        _kId: id,
        _kEmail: email,
        _kName: name,
      };

  Map<String, dynamic> toLoginJson() => {
        _kEmail: email,
        _kPassword: password,
        _kFcMId: userDevice?.fcmId ?? "",
        _kDeviceId: userDevice?.deviceId ?? "",
        _kRole: APISetup.userRole,
        _kTimeZone: timeZone,
      };

  Map<String, dynamic> toForgotPasswordJson() => {
        _kEmail: email,
      };

  Map<String, dynamic> toOTPJson() => {
        _kOTP: otp,
        _kPhone: phone,
      };

  Map<String, dynamic> toResendOTPJson() => {
        _kPhone: phone,
      };

  Map<String, dynamic> toLogoutJson() => {
        _kDeviceId: userDevice?.deviceId ?? "",
      };

  Map<String, dynamic> toChangePassword() => {
        _kPassword: password,
        _kNewPassword: newPassword,

        // _kConfirmPassword: confrimPassword,
        // _kEmail: emai.
      };

  Map<String, dynamic> toSignUpJson() => {
        _kName: name,
        _kEmail: email,
        _kPassword: password,
        _kAddress: address,
        _kInfo: info,
        _kLocation: locationModel,
        //! UNCOMMENT THIS
        _kPlaceId: placeId,
        _kRole: APISetup.userRole,
        _kDeviceId: userDevice?.deviceId ?? "",
        _kFcMId: userDevice?.fcmId ?? "",
        _kTimeZone: timeZone,
        _kPhone: phone,
      };

  Map<String, dynamic> toFirebaseJson(UserInfoModel userInfoModel) => {
        _kId: id,
        _kEmail: email,
        _kName: name,
        _kFcMIdList: [
          FcmIdModel(
            deviceId: userInfoModel.userDevice?.deviceId ?? "",
            token: userInfoModel.userDevice?.fcmId ?? "",
          ).toJson()
        ],
        _kFcMId: userInfoModel.userDevice?.fcmId ?? "",
        _kDeviceId: userInfoModel.userDevice?.deviceId ?? "",
        _kProfileImage: profileImage,
        StaticString.chattingWith: chattingWith,
        StaticString.unreadMessageCount: unreadMessageCount,
      };

  Map<String, dynamic> toUpdateProfileJson() => {
        _kEmail: email,
        _kName: name,
        _kInfo: info,
        _kPlaceId: placeId,

        // "delete_profile_photo": userPhotoIdForDelete?.join(",") ?? ""
      };

}

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

class ProfileModel {
  ProfileModel(
      {this.id,
      this.imgUrl = "",
      this.thumbnailUrl = "",
      this.isProfileImage = false,
      this.compressPath = "",
      this.originalPath = "",
      this.removeImage = false,
      this.index = 0});

  int? id;
  int index;
  String imgUrl, thumbnailUrl, compressPath, originalPath;
  bool isProfileImage, removeImage;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        imgUrl: json["image_url"] ?? "",
        thumbnailUrl: json["thumbnail_image_url"] ?? "",
        isProfileImage: json["is_profile_image"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imgUrl,
        "thumbnail_image_url": originalPath,
        "is_profile_image": isProfileImage,
      };

  cleanData() {
    id = null;
    imgUrl = "";
    originalPath = "";
    compressPath = "";
  }
}

class UserDevice {
  UserDevice({
    this.id,
    this.userId,
    this.deviceId = "",
    this.fcmId = "",
    this.pushNotification = false,
    this.emailNotification = false,
    this.toggleStripe = false,
  });

  int? id;
  int? userId;
  String deviceId;
  String fcmId;
  bool pushNotification;
  bool emailNotification;
  bool toggleStripe;

  factory UserDevice.fromJson(Map<String, dynamic> json) => UserDevice(
        id: json["id"],
        userId: json["user_id"],
        deviceId: json["device_id"] ?? "",
        fcmId: json["fcm_id"] ?? "",
        pushNotification: json["push_notification"] ?? false,
        emailNotification: json["email_notification"] ?? false,
        toggleStripe: json["toggle_stripe"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "device_id": deviceId,
        "fcm_id": fcmId,
        "push_notification": pushNotification,
        "email_notification": emailNotification,
        "toggle_stripe" : toggleStripe,
      };
}

