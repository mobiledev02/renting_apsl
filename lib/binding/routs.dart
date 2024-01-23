// ignore_for_file: prefer_const_constructors, constant_identifier_names

import 'package:get/get.dart';
import 'package:renting_app_mobile/screen/profile/verify_id_background_check_form_screen.dart';

import '../screen/rent/item/item_categories.dart';
import '../screen/rent/item/item_view_all_screen.dart';
import '../screen/rent/service/service_category.dart';
import '../screen/rent/service/service_detail_screen.dart';
import '../screen/rent/service/service_provider_profile_screen.dart';
import '../screen/rent/service/service_view_all_screen.dart';
import '/screen/auth/change_password_screen.dart';
import '../screen/chat/group_chat/group_wise_chat_list_screen.dart';
import '/screen/lend/my_lending_history_screen.dart';
import '../../binding/bindings.dart';
import '../models/user_model.dart';
import '../screen/auth/forgot_password_screen.dart';
import '../screen/auth/login_register_screen.dart';
import '../screen/auth/login_screen.dart';
import '../screen/auth/register_screen.dart';
import '../screen/chat/chat_list_screen.dart';
import '../screen/chat/chat_screen.dart';
import '../screen/history/history_detail_screen.dart';
import '../screen/history/lending_history_detail_screen.dart';
import '../screen/history/history_screen.dart';
import '../screen/home_screen_setup.dart';
import '../screen/lend/item_status_screen.dart';
import '../screen/lend/lend_home_screen.dart';
import '../screen/lend/lend_new_item_form_screen.dart';
import '../screen/lend/lend_new_service_form_screen.dart';
import '../screen/lend/service_status_screen.dart';
import '../screen/payment/checkout_screen.dart';
import '../screen/payment/payment_list_screen.dart';
import '../screen/payment/select_card_screen.dart';
import '../screen/profile/edit_Profile_Details_Screen.dart';
import '../screen/profile/how_To_Use_Screen.dart';
import '../screen/profile/notification_screen.dart';
import '../screen/profile/view_profile_screen.dart';
import '../screen/rent/browse_to_rent_items_screen.dart';
import '../screen/rent/item/item_detail_screen.dart';

import '../screen/request/end_request_screen.dart';
import '../screen/request/my_request_screen.dart';
import '../screen/request/request_item_screen.dart';
import '../screen/request/view_all_request_screen.dart';
import '../screen/request/view_requested_item_screen.dart';

late final UserInfoModel userInfoModel;

late final bool isLender;

// ignore: avoid_classes_with_only_static_members
class AppPages {
  static const INITIAL = "/LoginRegisterScreen";

  static final routes = [
    //----------------- Auth --------------
    GetPage(
      name: "/LoginRegisterScreen",
      page: () => LoginRegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: "/LoginScreen",
      page: () => LoginScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: "/RegisterScreen",
      page: () => RegisterScreen(),
      // binding: HomeBinding(),
    ),

    GetPage(
      name: "/ForgotPasswordScreen",
      page: () => ForgotPasswordScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: "/ChangePasswordScreen",
      page: () => ChangePasswordScreen(),
      // binding: HomeBinding(),
    ),

    //------------------- Home Setup------------
    GetPage(
      name: "/HomeSetupScreen",
      page: () => HomeSetUpScreen(),
      // binding: HomeBinding(),
    ),

    //------------------- Lend--------------------
    GetPage(
      name: "/LendHomeScreen",
      page: () => LendHomeScreen(),
      binding: LendBinding(),
    ),
    GetPage(
      name: "/LendNewItemFormScreen",
      page: () => LendNewItemFormScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: "/LendNewServiceFormScreen",
      page: () => LendNewServiceFormScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: "/ItemStatusScreen",
      page: () => ItemStatusScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: "/ServiceStatusScreen",
      page: () => ServiceStatusScreen(),
    ),
    GetPage(
      name: "/MyLendingHistoryScreen",
      page: () => MyLendingHistoryScreen(),
    ),

    //------------------- Request --------------------
    GetPage(
      name: "/ViewRequestedItemScreen",
      page: () => ViewRequestedItemScreen(),
    ),
    GetPage(
      name: "/EndRequestScreen",
      page: () => EndRequestScreen(),
    ),
    GetPage(
      name: "/MyRequestScreen",
      page: () => MyRequestScreen(),
    ),
    GetPage(
      name: "/RequestItemScreen",
      page: () => RequestItemScreen(),
    ),
    GetPage(
      name: "/ViewAllRequestScreen",
      page: () => ViewAllRequestScreen(),
    ),

    //------------------- Payment --------------------
    GetPage(
      name: "/CheckoutScreen",
      page: () => CheckoutScreen(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: "/PaymentListScreen",
      page: () => PaymentHistoryScreen(),
    ),
    // GetPage(
    //   name: "/PaymentScreen",
    //   page: () => PaymentScreen(),
    // ),
    GetPage(
      name: "/SelectCardScreen",
      page: () => SelectCardScreen(),
    ),

    //------------------- Profile --------------------
    GetPage(
      name: "/EditProfileDetailScreen",
      page: () => EditProfileDetailScreen(),
    ),
    GetPage(
      name: "/HowToUseScreen",
      page: () => HowToUseScreen(),
    ),
    GetPage(
      name: "/NotificationScreen",
      page: () => NotificationScreen(),
    ),
    GetPage(
      name: "/ViewProfileScreen",
      page: () => ViewProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: "/VerifyIDBackgroundCheckFormScreen",
      page: () => VerifyIDBackgroundCheckFormScreen()
    ),

    //----------------------- History -------------------
    GetPage(
      name: "/HistoryScreen",
      page: () => HistoryScreen(),
    ),
    GetPage(
      name: "/HistoryDetailScreen",
      page: () => HistoryDetailScreen(),
    ),
    GetPage(
      name: "/LendingHistoryDetailScreen",
      page: () => LendingHistoryDetailScreen(),
    ),
    //------------------- Rent --------------------
    GetPage(
      name: "/BrowseToRentItemsScreen",
      page: () => BrowseToRentItemsScreen(),
      binding: RentBinding(),
    ),
    GetPage(
      name: "/ItemDetailScreen",
      page: () => ItemDetailScreen(),
    ),
    GetPage(
      name: "/ServiceDetailScreen",
      page: () => ServiceDetailScreen(),
    ),
    GetPage(
      name: "/ItemCategoriesScreen",
      page: () => ItemCategoriesScreen(),
    ),
    GetPage(
      name: "/ServiceCategoriesScreen",
      page: () => ServiceCategoriesScreen(),
    ),

    GetPage(
      name: "/ItemViewAllScreen",
      page: () => ItemViewAllScreen(),
    ),

    GetPage(
      name: "/ServiceViewAllScreen",
      page: () => ServiceViewAllScreen(),
    ),

    GetPage(
      name: "/ServiceProviderProfileScreen",
      page: () => ServiceProviderProfileScreen(),
    ),

    //------------------------- Chat ---------------------

    GetPage(
      name: "/ChatListScreen",
      page: () => ChatListScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: "/ChatScreen",
      page: () => ChatScreen(
        isLender: isLender,
        userInfoModel: userInfoModel,
      ),
    ),
    GetPage(
      name: "/GroupWiseChatListScreen",
      page: () => GroupWiseChatListScreen(Get.arguments),
    ),
  ];
}
