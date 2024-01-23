import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:renting_app_mobile/controller/job_offer_controller.dart';
import 'package:renting_app_mobile/controller/payment_controller.dart';
import '/binding/bindings.dart';
import '/controller/auth_controller.dart';
import '/controller/category_controller.dart';
import '/controller/chat_controller.dart';
import '/controller/end_request_controller.dart';
import '/controller/how_to_use_controller.dart';
import '/controller/lend_controller.dart';
import '/controller/request_controller.dart';
import '/screen/auth/login_register_screen.dart';
import '../constants/custom_theme.dart';
import '../screen/home_screen_setup.dart';
import 'api/api_middleware.dart';
import 'binding/routs.dart';
import 'controller/item_controller.dart';
import 'controller/notification_controller.dart';
import 'controller/total_payment_controller.dart';
import 'controller/dev_stripe_key_toggle_controller.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get getContext => navigatorKey.currentState!.context;
AuthController? getAuthController;
ChatController? getChatController;

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   debugPrint("Handling a background message: ${message.messageId}");
// }

Future<void> main() async {
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey =
      'pk_live_51M34hGLqByjofhET7oCYFR3EzHEyvsVflh3m3TSF8OMAEOlFldQnupK0agP1dHxmKrqp3bYAFJyfvJ6zOgJGZx7q00u1WfH8Xh';
  getAuthController = Get.put<AuthController>(AuthController());
  getChatController = Get.put<ChatController>(ChatController());
  Get.put(ItemController());
  // Get.put(ItemDetailController());

  Get.put(LendController());
  Get.put(HowToUseController());
  Get.put(EndRequestController());
  Get.put(TotalPaymentController());
  Get.put(RequestController());
  Get.put(CategoryContoller());
  Get.put(NotificationController());
  Get.put(PaymentController());
  Get.put(JobOfferController());
  Get.put(StripeKeyController());

//generate random numbers between

  //remove badge...
  // if (Platform.isIOS) {
  //   FlutterAppBadger.removeBadge();
  // }

  try {
    await ApiMiddleware.getDefaultParams();
  } catch (e, st) {
    debugPrint("------------------main error------------------");

    debugPrint('error $e $st');
  }
  /// Use firebase emulators
  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //     debugPrint('emulator working');
  //   } catch (e, st) {
  //     debugPrint('emulator error $e $st');
  //   }
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      initialBinding: AuthBinding(),
      theme: CustomAppTheme.lightTheme,
      getPages: AppPages.routes,
      // home: AttachStripeAccountScreen(),
      home: Obx(
        () => Get.find<AuthController>().isUserLoggedIn.value
            ? HomeSetUpScreen()
            : LoginRegisterScreen(),
      ),
    );
  }
}
