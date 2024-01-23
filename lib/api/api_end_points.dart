import '../../utils/url_switcher_screen.dart';
import '../models/user_model.dart';
import '../utils/custom_enum.dart';

class APISetup {
  static const String productionURL =
      "https://staging.rentingandlending.com/api/";

  // static const String productionURL = 'http://192.168.10.32:9500/api/';

  static const String stagingURL = "https://staging.rentingandlending.com/api/";
  static const String localURL = "http://192.168.29.229:8000/api/";
  static const URLType urlTypeToTest = URLType.None;
  static const String errorMessageKey = 'message';
  static const String errorTitleKey = 'title';
  static const String statusKey = 'status';
  static const String userStatusKey = 'user_status';
  static const String dataKey = 'data';
  static const String datasetKey = 'dataset';
  static const String userRole = 'user';
  static const String apiKey = 'e32bf8eecbac41d2b2ec1c38615e1441';
  static const String googlePlaceKey =
      "AIzaSyDdolr--XrpRST3lQd2hzvo4AAq9l4GDcg";
  static const int lazyLoadLimit = 10;
  static const double imageUploadSizeLimit = 10.0;
}

//End Points...
class EndPoints {
  static AuthEndPoints auth = AuthEndPoints();
  static EventEndPoints event = EventEndPoints();
}

class EventEndPoints {
  static const String locationUpdate = "auth/location-update"; //! remaining

  /// Lend item service

  static const String categories = "categories?type=";
  static const String lendItem = "lend-item";
  static const String lendServices = "lend-services";
  static const String createItem = 'create-item';
  static const String createItemAndService = "lend-item-service";
  static const String detail = "lend-item-service/";
  static const String updateItemAndService = "lend-item-service/";
  static const String deleteItemAndService = "lend-item-service/";
  static const String rates = "rates";
  static const String myLending = "my-items-services";

  /// item service rented
  static const String rent = "lend-item-service/";
  static const String rentItemServiceDetail = "rented-item-detail";
  static const String rentServiceDetail = "rented-service-detail";

  /// Request
  static const String createRequest = "request-item";
  static const String requestItems = "request-items";
  static const String requestItem = "request-item/";
  static const String myRequestList = "my-request-item";
  static const String deleteRequest = "my-request/";
  static const String itemServiceRent = "item-service-rent";
  static const String createTransaction = "create-transaction";
  static const String sendNotificationRenterAccept = "send-push-notification";

  /// stripe
  static const String createStripeAccount = "create-stripe-account";
  static const String deleteStripeAccount = "delete-stripe-account";

  /// Payment
  static const String getPayment = "payments";
  static const String saveCard = "save-user-card";

  /// Account Balance
  static const String getAccountBalance = 'get-balance';
  static const String withdrawBalance = 'transfer-to-bank';

  /// Review
  static const String submitReview = "give-review";

  /// Lender profile
  static const String lenderProfile = "user-profile";
  static const String submitVerification = 'update-profile';

  /// notification
  static const String notification = "notification";
  static const String deleteNotification = "delete-notification/";
  static const String deleteAllNotification = "delete-all-notification";

  /// check out
  static const String createCheckout = "checkout";
  static const String miles = "miles";
  static const String serviceProviderDetail = "lend-services/details/";

  /// Service job offer
  static const String sendJobOffer = 'send-offer';
  static const String getOffers = 'get-offers';
  static const String getOffer = 'get-offer';
  static const String getAllOffers = 'all-offers';
  static const String checkOffer = 'check-offer';
  static const String offerAction = 'offer-action';
  static const String accept = 'accept';
  static const String reject = 'reject';
  static const String hire = 'hire';
  static const String loggHours = 'log-hours';
  static const String dispute = 'dispute';
}

// Auth...
class AuthEndPoints {
  static const String signUp = 'auth/register';
  static const String signIn = 'auth/login';
  static const String otpEndPoint = 'auth/verify/otp';
  static const String resendOTP = 'auth/resend/otp';
  static const String updateProfile = 'auth/profile-update';
  static const String myProfile = 'auth/my-profile?device_id=';
  static const String updateNotification = "auth/update-notification";
  static const String logOut = 'auth/logout';
  static const String deleteAccount = 'auth/delete';
  static const String forgotPassword = 'auth/password/forgot';
  static const String changePassword = 'auth/change-password';
  static const String createEvent = 'auth/event';
  static const String contactSupport = 'contact-support';
  static const String feedBack = 'feedback';
  static const String report = 'report-user';
  static const String locationUpdate = 'auth/location-update';

  String authEndpoint(UserInfoModel userInfo) {
    String endPoint = "";
    switch (userInfo.authType) {
      case AuthType.Login:
        endPoint = signIn;
        break;

      case AuthType.SignUp:
        endPoint = signUp;
        break;

      case AuthType.OTP:
        endPoint = otpEndPoint;
        break;
      case AuthType.resentOTP:
        endPoint = resendOTP;
        break;
      case AuthType.ForgotPassword:
        endPoint = forgotPassword;
        break;

      case AuthType.ChangePassword:
        endPoint = changePassword;
        break;

      case AuthType.UpdateProfile:
        endPoint = updateProfile;
        break;

      case AuthType.SetFcmToken:
        break;

      case AuthType.TermsAndCondition:
        break;

      case AuthType.PrivacyPolicy:
        break;

      case AuthType.Logout:
        endPoint = logOut;
        break;

      case AuthType.DeleteAccount:
        endPoint = deleteAccount;
        break;

      case AuthType.None:
        throw "Please select valid auth type";
    }
    return endPoint;
  }
}
