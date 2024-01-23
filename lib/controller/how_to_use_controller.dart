import 'package:get/get_state_manager/get_state_manager.dart';

import '../constants/img_font_color_string.dart';
import '../models/how_to_use_model.dart';

class HowToUseController extends GetxController {
  static const listOfHowToUseJson = [
    {
      "icon": ImgName.rentImage,
      "title": "Rent",
      "description": "Rent items from people in your community."
    },
    {
      "icon": ImgName.lendImage,
      "title": "Lend",
      "description": "Earn money by lending items you are not using."
    },
    {
      "icon": ImgName.request,
      "title": "Request",
      "description": "Request an item to rent if it is not already availlable."
    },
    {
      "icon": ImgName.chatIcon,
      "title": "Chat",
      "description": "Chat with renter/lender to coordinate a pickup / dropoff."
    },
  ];

  List<HowToUseModel> listOfHowToUse = List<HowToUseModel>.from(
    listOfHowToUseJson.map(
      (e) => HowToUseModel.fromJson(e),
    ),
  );
}
