import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/chat_controller.dart';

import '../controller/end_request_controller.dart';
import '../controller/how_to_use_controller.dart';
import '../controller/item_controller.dart';
import '../controller/lend_controller.dart';
import '../controller/total_payment_controller.dart';

//  Get.put(AuthController());
//   Get.put(ChatController());
//   Get.put(ItemController());
//   Get.put(LendController());

//   Get.put(HowToUseController());
//   Get.put(EndRequestController());
//   Get.put(TotalPaymentController());
//   Get.put(ItemController());

class HomeBinding extends Bindings {
  @override
  void dependencies() {}
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatController>(ChatController());
  }
}

class LendBinding extends Bindings {
  @override
  void dependencies() {}
}

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TotalPaymentController>(TotalPaymentController());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HowToUseController>(HowToUseController());
  }
}

class RentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItemController>(ItemController());

    Get.put<LendController>(LendController());
  }
}

class RequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EndRequestController>(EndRequestController());
  }
}
