import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:renting_app_mobile/constants/img_font_color_string.dart';
import 'package:renting_app_mobile/controller/auth_controller.dart';

import 'custom_text.dart';

class HomeChatCounter extends StatelessWidget {
  const HomeChatCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(StaticString
              .chatCounterCollection)
          .doc(Get.find<AuthController>().getUserInfo.id.isNotEmpty ? Get.find<AuthController>().getUserInfo.id : '0')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox();
        }


        // Access the document data
        final data = snapshot.data!.data() as Map<String, dynamic>;

        // Use the document data in your UI
        if (data['unreadMessages'] > 0) {
          return Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: custRedFC5A59,
              borderRadius: BorderRadius.circular(
                50,
              ),
            ),
            alignment: Alignment.center,
            child: CustomText(
              txtTitle: data['unreadMessages'].toString(),
              //userInfoModel.unreadMessageCount.toString(),
              align: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
