// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '/cards/chat_card.dart';
// import '/controller/chat_controller.dart';
// import '/widgets/common_widgets.dart';
// import '/widgets/custom_text.dart';

// import '../../models/user_model.dart';

// class AppsUserListScreen extends StatelessWidget {
//   const AppsUserListScreen({Key? key}) : super(key: key);

//   ChatController get getChatController => Get.find<ChatController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustBackButton(),
//           ],
//         ),
//       ),
//       body: StreamBuilder(
//         stream: getChatController.getAllTheUsersList(),
//         //chatController.recentChatRef.snapshots(),
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           // ignore: avoid_print
//           List<UserInfoModel> userList = [];
//           // print(snapshot.data?.docs.length);

//           snapshot.data?.docs.forEach((element) {
//             userList.add(
//               UserInfoModel.fromJson(
//                 element.data(),
//               ),
//             );
//           });

//           return ListView.builder(
//             itemCount: userList.length,
//             itemBuilder: (context, index) => ChatCard(
//               userInfoModel: userList[index],
//               showCount: false,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
