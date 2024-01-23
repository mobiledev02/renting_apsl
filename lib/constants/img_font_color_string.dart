// ignore_for_file: constant_identifier_names, avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/custom_enum.dart';

// ignore: avoid_classes_with_only_static_members
class StaticString {
  static const String appName = "reLend";
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String copyRight = "Copyright";
  static const String version = 'Version';
  static const String no = "No";
  static const String yes = "Yes";
  static const String retry = "Retry";
  static const String noDetailFound = "No detail found";
  static const String skip = "Skip";
  static const String send = "Send";
  static const String settings = "Settings";
  static const String update = "Update";
  static const String newUpdateAvailable = "New Update Available";
  static DateFormat formatter = DateFormat("MM/dd/yyyy");

  static const String chattingWith = "chatting_with";
  static const String blockBy = "blockBy";
  static const String unreadMessageCount = "unread_message_count";
  static const String addImage = "Add Image";
  static const String rupeeSymbol = "\u{20B9}";

  // ----------------- Login Or Register Screen --------------------------------

  static const String login = "Login";
  static const String register = "Register";

  //-----------------Login Screen------------------------------------------
  static const String forgotPassword = "Forgot Password?";
  static const String LOGIN = "LOG IN";

  //-----------------Register Screen------------------------------------------
  static const String name = "Name";
  static const String emailID = "Email Address";
  static const String phone = "Phone Number";
  static const String password = "Password";
  static const String chooseFile = "Choose File";
  static const String fileFormatText = "JPG, GIF or PNG. Max size of 800K";
  static const String moreInfoAboutYou = "More info about you";
  static const String address = "Address";

  //-----------------OTP Screen------------------------------------------
  static const String verifyTitle = "Verification Code";

  static String getOTPString(String number) {
    return "Enter 4-digit code sent to you at $number";
  }

// --------------------- Forgot password Screen ----------------------------
  static const String dontWorry =
      "Don't worry! It happens. Please enter the address accociated with your account.";
  static const String sent = "SENT";

// --------------------- Change password Screen ----------------------------
  static const String submit = "Submit";
  static const String changePassword = "Change Password";
  static const String currentPassword = "Current Password";
  static const String newPassword = "New Password";
  static const String confirmPassword = "Confirm Password";

// --------------------------- Location Dialog---------------------------------

  static const String allowYourLocation = "Allow your location";

  static const String weWillNeed =
      "We will need your location to give you batter experience.";
  static const String allowLocation = "Allow Location";
  static const String maybeLater = "Maybe Later";

//---------------------Browse To Rent Items Screen--------------------
  static const String balance = "Total \$ Pending: ";
  static const String reLend = "reLend";
  static const String request = "Request";
  static const String search = "Search";
  static const String servicesAndItems = "Services";
  static const String services = "Services";
  static const String categories = "Categories";
  static const String itemsNearYou = "Items Near You";
  static const String helpersNearYou = "Helpers Near You";
  static const String searchResults = "Search Results";
  static const String seeProfile = "See Profile";
  static const String items = "Items";
  static const String findTheBestThing = "Find the best thing";
  static const String viewAll = "View All";
  static const String viewMore = "View More";
  static const String noResults = "No Results";
  static const String noItemsToLeftShow = "No items available yet";
  static const String noServicesLeftToShow = "No services available yet";
  static const String filter = "Filter";
  static const String item = "item";
  static const String service = "Service";

//---------------------- Item Detail Screen --------------------------

  static const String itemnDetail = "Item Details";
  static const String maxDurationDay = "Max. Duration: ";
  static const String woodhouseBarn = "Woodhouse Barn";
  static const String price = "Price";
  static const String selectDate = "Select Date";
  static const String selectHours = "Select Hours";
  static const String startDate = "Start Date";
  static const String startTime = "Start Time";
  static const String date = "mm/dd/yy";
  static const String endDate = "End Date";
  static const String endTime = "End Time";
  static const String checkPrice = "Check Price";
  static const String perDayPrice = "(Per Day Price*Selected Days)";
  static const String finalPrice = "Final Price:";
  static const String rent = "Rent";
  static const String chatWithLender = "Chat With Lender";
  static const String selectDuration = "Select Duration";
  static const String details = "Details";
  static const String info =
      "You will get this amount back after safely returning the item to the Lender.";
  static const String serviceFeeTooltip = '3% of price + 30 cents';



  //----------------------- Request Item Screen ---------------
  static const String requestAnItem = "Request an Item";
  static const String imLookingFor = "I’m Looking for...";
  static const String yourItem = "Your Item:";

  static const String needItby = "Need it by:";
  static const String selectMiles = "Select miles:";
  static const String tapToAgreeToOurTermsAndConditions =
      "Tap to agree to our terms & conditions";
  static const String post = "Post";
  static const String requestCreatedSuccessfully =
      "Request created successfully";

  //----------------------------------Lend Home Screen-----------------------
  static const String lendingHomeScreen = "Lending Home Screen";
  static const String requestsNearYou = "Requests Near You";
  static const String request1 = "Request 1";
  static const String macBook = "MacBook Air with Apple M1 chip";
  static const String yourLendingHistory = "Your Lending History";
  static const String lendNewItem = "Lend New Item";
  static const String lendEditItem = "Edit Item";
  static const String lendNewService = "Lend New Service";
  static const String lendEditService = "Edit Service";
  static const String lendAService = "Lend a Service";
  static const String whoops = "Whoops!";
  static const String lookLikeTheresNoData = "Look like there's no data.";
  static const String myLendingHistory = "My lending history";

//----------------------- Lend new item form Screen-------------------

  static const String itemName = "Item Name:";
  static const String hintItemName = "Enter item name";
  static const String location = "Location:";
  static const String hintLocation = "Enter location";
  static const String description = "Description:";
  static const String hintDescription = "Enter description";
  static const String hintDuration = "Enter duration";
  static const String exchangePref = "Item Exchange Preference";
  static const String returnPref = "Item Return Preference";
  static const String enterValue = "Enter Value in USD: (max 5000)";
  static const String enterValue2 = "Enter Hourly Rate in USD";
  static const String hintValue = "Enter value";
  static const String lend = "Lend";

  static const String itemCategory = "Item Category:";
  static const String itemCategoryTitle = "Item Categories";
  static const String select = "Select:";
  static const String rate = "Rate";
  static const String hire = "Hire";
  static const String sendOffer = "Send Offer";
  static const String dayilyRate = "Daily #(+5%)";
  static const String perDay = "(Per Day)";
  static const String perWeek = "(Per Week)";
  static const String perMonth = "(Per Month)";
  static const String safetyDeposite =
      "Security Deposit"; //#(not #more #then #item #value)
  static const String serviceFee = 'Service Fee';
  static const String hintsafetyDeposite = "50% of item value";

  static const String optInInsurance = "Opt-in Insurance";
  static const String maxDuration = "Max Duration (Days):";

  static const String serviceName = "Service Name:";
  static const String hintServiceName = "Enter Service name";
  static const String serviceCategory = "Service Category:";
  static const String serviceCategoryTitle = "Service Categories";
  static const String serviceProviders = "Service Providers";
  static const String itemCreatedSuccessfully = "Item created successfully";
  static const String itemUpdatedSuccessfully = "Item updated successfully";
  static const String serviceCreatedSuccessfully =
      "Service created successfully";
  static const String serviceUpdatedSuccessfully =
      "Service updated successfully";
  static const String optText = 'If you opt-in to insurance, then you will earn 75% of the renting price (daily rate x number of days). You will be fully reimbursed per the item value in the event that a Renter breaks or misplaces your item during the renting period. If you choose not to opt-in to insurance, then you will not be fully reimbursed in the event that a Renter breaks or misplaces your item during the renting period. You will only be reimbursed via the Renter’s security deposit. However, you will earn 85% of the Renting Price, instead of 75%.';


  //-------------------- End Request Screen---------------------------
  static const String endRequestItem = "End Request Item";
  static const String ourTermsAndConditions = "Our terms & conditions";

  /// --------------------- my request Screen ------------------
  static const String myRequest = "My Request";

  /// --------------------- View all request Screen ------------------
  static const String allRequest = "All Request";

  /// --------------------- Lender Profile Screen -------------------
  static const String reviews = "Reviews";

  /// -------------------- Item Status Screen -----------------------

  static const String maxTerm = "Max. Term";
  static const String rentedBy = "Rented by";
  static const String failed = "Failed";
  static const String delete = "Delete Listing";
  static const String editListing = 'Edit Listing';
  static const String itemDeleteAlertMsg =
      "Are you sure want to delete this item?";
  static const String serviceDeleteAlertMsg =
      "Are you sure want to delete this service?";

  //------------------- View Request item Screen------------------
  static const String someoneInYourAreaWantsToBorrowAnItem =
      "Someone in your area wants to borrow an item!";
  static const String requestDeleteAlertMsg =
      "Are you sure want to delete this request?";

  //-------------------------- View Profile Screen-----------------
  static const String edit = "Edit";
  static const String totalBalance = "Total Balance:";
  static const String myPayments = "My Payments";
  static const String aboutMe = "About Me";
  static const String accountStatusTitle = "Account Status";
  static const String accountStatusActive =
      "Account is connected to receive payments";

  static const String serviceImages = "Service Images";
  static const String pushNotifications = "Push Notifications";
  static const String emailNotifications = "Email Notifications";
  static const String testStripeNotifications = "DEV: Stripe Keys Test Mode Enabled";
  static const String howToUseThisApp = "How to Use";
  static const String myRequests = "My Requests";
  static const String history = "HISTORY";
  static const String logoutAlertMsg = "Are you sure want to logout?";

  static const String logOut = "LOG OUT";

  static const String maximumHours = "Maximum Hours";
  static const String jobDescription = "My Job Requirements";
  static const String jobQ1 = "Please describe the task / service that you need. Be as detailed as possible.";
  static const String jobQ2 = "What are your expectations for this service?";
  static const String jobQ3 = "Are there any particular challenges, preferences, or unique aspects related to this job that the service provider should be aware of?";

  //------------------------- Edit Profile Detail Screen ----------------
  static const String profile = "Profile";
  static const String changeAvatar = "Change Avatar";
  static const String userName = "User’s Name:";
  static const String userEmail = "User’s Email:";

  //------------------------- Notification Screen ---------------------------
  static const String notifications = "Notifications";

  //--------------------------- Payment Screen------------------------
  static const String paymentScreen = "Transactions History";
  static const String transactions = "Transactions";
  static const String manageStripeAccount = "Manage Stripe Account";

  static const String addNewCard = "Add New Card";
  static const String done = "Done";

  //-------------------------- Payment List Screen---------------------------
  static const String sortby = "Sort by";
  static const String filterby = "Filter by";
  static const String noTransactions = "No Transactions";
  static const String wtDontSee =
      "We don't see any records from \nyour history.";

  // ------------------------- Checkout Screen -----------------------
  static const String checkout = "Checkout";
  static const String lenderName = "Lender Name:";
  static const String rentDuration = "Rent Duration:";
  static const String renterDetails = "Renter Details:";
  static const String payWith = "Choose billing method:";
  static const String itemInfo = "Item Info:";
  static const String itemPrice = "Item Price";
  static const String charges = "Charges";
  static const String totalPayment = "Total Payment";
  static const String confirmAndPay = "Confirm and Pay";
  static const String warningMsg =
      "Check all the items images with lender via Chat before you pay for the item.";

//--------------------------- History screen ----------------------------
  static const String lendorDetails = "Lendor Details";
  static const String email = "Email:";

  static String writeAReview(String name) {
    return "Write a review for $name";
  }

  //------------------------ How to use  Screen------------------

  static const String howToUseApp = "How to use app";
  static const String exit = "Exit";

  //------------------------------------- chat Screen -----------------------
  static const String nothingHere = "Nothing Here";
  static const String pickPerson =
      "Pick person from right button \n and start your conversation";
  static const String conversations = "Conversations";
  static const String clear = "Clear";
  static const String confirm = "Confirm";
  static const String deletAccount = "Delete account";
  static const String deletAccountMessage =
      "Are you sure you want to delete your account?";
  static const String userCollection = "users";
  static const String mainUserCollection = "staging_users";
  static const String recentChatCollection = "recentChats";
  static const String chatCollection = "chats";
  static const String messageCollection = "messages";
  static const String groupChatsCollection = "group_chat";
  static const String singleChatsCollection = "single_chat";

  //-------------------------------------- chat request model----------------------
  static const String itemRequestsCollection = 'item_requests';
  static const String itemRequestStatus = 'item_request_status';
  static const String serviceRequestCollection = 'service_requests';
  static const String serviceChatCollection ='service_chat';
  static const String chatCounterCollection = 'chat_counter';

  // --------------------------------- notification screen  ------------------------
  static const String notificationDeleteAlertMsg =
      "Are you sure want to delete this notification?";
  static const String notificationDeleteAllAlertMsg =
      "Are you sure want to delete all notification?";
  static const String deletetxt = "DELETE";
  static const String cancletxt = "CANCLE";

  static const String admin = "Admin";

  //------------------------------------- Service detail screen -----------------------
  static const String perdayPriceSelectedDays =
      "(Per Day price/24 x Selected Hours)";
  static const String hoursPrice = " Hours Price";

  static const String daysPrice = " Hour Price";

  static const String paymentSuccessful = "Payment successful. Thank you.";
  static const String pendingPaymentMessage =
      "We are currently processing your payment. Your status will be updated within 24 hours. Thank you for your patience.";
  static const String failedPaymentMessage =
      "Unfortunately your payment request is failed. please try again.";
  static const String declinedPaymentMessage =
      "Oh snap! Your card information was declined";
  static const String notVerifiedText = 'Warning: This user has not completed at least 10 jobs successfully.';
  static const String verifiedText = 'This user has completed at least 10 jobs with no flags.';

  // static const String notVerifiedText = 'Warning: This user has not gone through a criminal background check via Checkr or has not cleared the background check';
  // static const String verifiedText = 'This user has cleared a criminal background check via Checkr';

  //----------------------------------- Service job Offer--------------------------------


  static String getPaymentStatusMessages(String paymentStatus) {
    String image = paymentSuccessful;
    switch (paymentStatus) {
      case "done":
        image = paymentSuccessful;
        break;
      case "pending":
        image = pendingPaymentMessage;
        break;
      case "failed":
        image = failedPaymentMessage;
        break;
      case "processor_declined":
        image = declinedPaymentMessage;
        break;
    }

    return image;
  }
}

//-------------------------------------------------------------------------Alert Messages---------------------------------------------------------------------------//
class AlertMessageString {

  static const String invalidRate = 'Please enter valid rate';
  static const String invalidSSN = 'Please enter a valid SSN';
  static const String maxHour = "Hours cannot be empty";
  static const String socketException = 'Please try again later';

  static const String noInternet = "No Internet";
  static const String noInternetMsg = "Please check your internet connection";

  static const String unAuthorisedTitle = "UnAuthorised";
  static const String unAuthorisedMsg =
      "The session is expired due to security reasons, please login again to continue.";

  static const String defaultErrorTitle = "Error";
  static const String somethingWentWrong =
      "Something went wrong, please try again later...";
  static const String underMaintainanceTitle = "Under Maintainance";
  static const String underMaintainanceMsg =
      "Sorry, we're down for scheduled maintenance right now, please try after some time.";
  static const String invalidFormat = "Invalid format";
  static const String httpErrorMsg = "The server is currently unavailable.";

  static const String galleryPermissionError =
      "Go to Settings - Photos and grant permission to access photo  to set your profile picture.";

  // static const String cameraPermissionError = "";
  //-----------------auth alert----------------------
  static const String emptyName = "Please enter your name";
  static const String emptyEmail = 'Please enter your email';
  static const String inavlidPhone = 'Invalid mobile number';
  static const String validEmail = 'Please enter a valid email';
  static const String emptyPwd = 'Please enter your password';
  static const String validPassword = 'Please enter atleast 8 characters';
  static const String emptyConfirmPwd = 'Please enter confirm password';
  static const String passwordDoNotMatch = 'Password doesn`t match.';
  static const String emptyUserProfile = 'Please upload an image';
  static const String emptyMoreInfo = "Please enter more Information";
  static const String emptyAddress = "Please enter your address";
  static const String emptyCode = "Please enter OTP.";
  static const String validyCode = "Please enter valid OTP.";
  static const String resetPasswordLinkHasBeenSent =
      "Reset password link sent to your email";

//---------------------- Review Alert-----------------------
  static const String emptyReview = "Please provide review";
  static const String shortReview = "Review is too short";

  static const String termsAndConditionsAggreement =
      "Please select terms & conditions.";

  //------------------- Verify Identity Background Check Alert ----------

  static const String emptyFirstName = "First Name is required";
  static const String emptyLastName = "Last Name is required";
  static const String emptyDob = "Date of Birth is required";
  static const String emptySsn = "Social Security Number is required";
  static const String emptyZipCode = "Zip Code is required";

//--------------------- New Lend Item Alert---------------
  static const String emptyItemName = "Please enter name";
  static const String emptyItemCategory = "Please select item category";
  static const String emptylocation = "Please enter location";
  static const String emptyDescription = "Please enter description";
  static const String emptyValue = "Please enter value";
  static const String emptyDuration = "Please enter Duration";
  static const String invalidDuration = "Max duration should be grater then 0";
  static const String emptyRatePerDay = "Please enter rate";
  static const String incorrectRetePerDay = "Please enter correct rate";
  static const String emptyRatePerWeek = "";
  static const String emptyRatePerMonth = "";
  static const String emptySafetyDeposite = "Please enter safety deposite";
  static const String invalidSafetyDeposite =
      "Please enter security deposit less than value";
  static const String emptyCategoryType = "Please select category";
  static const String emptyExchangePref = "Please select exchange preference";
  static const String emptyReturnPref = "Please select return preference";
  static const String emptyLenderType = "Please select service category";
  static const String emptyImage = 'Please upload at least 2 images ';

  // ------------------ Permission Messages -------------------
  static const String permissionDenied = "Permission denied";

  static const String allowContactMsg =
      "Access to the Contact is denied for this app, go to settings, and allow Contact permission";
  static const String allowLocationMsg =
      "Access to the Location is denied for this app, go to settings, and allow Location permission";
  static const String allowCameraMsg =
      "Access to the Camera is denied for this app, go to settings, and allow Camera permission";
  static const String allowPhotoesMsg =
      "Access to the Photos is denied for this app, go to settings, and allow Photos permission";
}

//------------------------------Images Path----------------------------//

class ImgName {
  static const imgPath = "assets/images";

  //--------------------  splash  Screen-----------------
  static const String noUser = "$imgPath/noUser.png";
  static const String logo = "$imgPath/logo.png";
  static const String hill = "$imgPath/hill.svg";

  // static const String frame = "$imgPath/frame.svg";

  //---------------------------Login or Register Screen----------------
  static const String loginRegisterImage = "$imgPath/loginOrRegPage.png";

  //---------------------------Login  Screen----------------
  static const String email = "$imgPath/emailIcon.png";

  static const String password = "$imgPath/passwordIcon.svg";

  //---------------------------Register Screen Images ----------------------
  static const String registerImage = "$imgPath/registerPage.png";
  static const String emailIcon = '$imgPath/email.svg';
  static const String phone = '$imgPath/phone.svg';
  static const String dottendBorder = '$imgPath/dotted_border.svg';
  static const String locationIcontextFormField =
      '$imgPath/locationIcontextFormField.svg';
  static const String user = '$imgPath/user.png';
  static const String closeWithBg = '$imgPath/closeWithBg.png';
  static const String tickWithBg = '$imgPath/tickWithBg.png';
  static const String clockWithBg = '$imgPath/clockWithBg.png';
  static const String chooseUserImage = '$imgPath/chooseUserImage.png';

  //---------------------------Register Screen Images ----------------------
  static const String loginImage = "$imgPath/loginPage.png";

  //---------------------------Forgot Password Screen Images ----------------------
  static const String forgotPasswordImnage = "$imgPath/forgotPasswordBg.svg";

  //---------------------------Reset Password Screen Images ----------------------
  static const String resetPasswordImnage = "$imgPath/resetPasswordBg.svg";

  //---------------------------Locatio Permission Popup Screen Images ----------------------
  static const String locationDialogImage = "$imgPath/locationDialogBg.svg";

  //----------------------------Browse To Rent Items Screen ----------------------

  static const String profileImage = "$imgPath/profileImage.png";
  static const String searchImage = "$imgPath/search.png";
  static const String distanceImage = "$imgPath/distance.svg";
  static const String homeImage = "$imgPath/home.svg";
  static const String laptopImage = "$imgPath/laptop.png";
  static const String rentImage = "$imgPath/rent.svg";
  static const String lendImage = "$imgPath/lend.svg";
  static const String profileImage1 = "$imgPath/profile.svg";
  static const String chatImage = "$imgPath/chat.svg";
  static const String filter = "$imgPath/filter.svg";
  static const String filterPng = "$imgPath/filter.png";
  static const String browseEmptyImage = "$imgPath/browseEmptyBg.png";
  static const String notificationIcon = "$imgPath/notificationIcon.svg";
  static const String divider = "$imgPath/divider.png";
  static const String delete = "$imgPath/delete.png";

  //------------------------------Lend home screen-----------------------
  static const String requestCardBackground =
      "$imgPath/requestCardBackground.png";
  static const String tag = "$imgPath/tag.svg";
  static const String emptylendingImage = "$imgPath/emptylendingImage.png";
  static const String location = "$imgPath/locationIcon.svg";
  static const String locationPlain = "$imgPath/location.svg";
  static const String requestLocation = "$imgPath/requestLocation.png";

  static const String editButton = "$imgPath/edit.png";
  static const String editButton2 = "$imgPath/editButton.svg";
  static const String deleteButton = "$imgPath/deleteButton.svg";
  static const String image1 = "$imgPath/image1.png";
  static const String image2 = "$imgPath/image2.png";
  static const String image3 = "$imgPath/image3.png";
  static const String item = "$imgPath/item.png";
  static const String tick = "$imgPath/tick.png";
  static const String calender2 = "$imgPath/calendar_dotted.png";

  //----------------------------------Lend New Item Form Screen -------------------

  static const String backArrowImage = "$imgPath/backArrow.png";
  static const String backArrowWhiteBgImage = "$imgPath/backArrowWhiteBg.png";
  static const String imagePlacheHolderImage = "$imgPath/frame.svg";
  static const String locationImage = "$imgPath/location.svg";
  static const String dropDownIcon = "$imgPath/dropDownIcon.svg";
  static const String uploadyourDocumentImage =
      "$imgPath/uploadyourDocument.svg";

  //----------------------------- Item Detail -------------------
  static const String dayIcon = "$imgPath/dayIcon.svg";
  static const String calender = "$imgPath/calender.png";
  static const String calender3 = "$imgPath/calender3.png";
  static const String infoIcon = "$imgPath/infoIcon.png";

  //----------------------------- Service  Detail -------------------
  static const String clock = "$imgPath/clock.png";

  //--------------------------------Vew Profile Screen------------------------
  static const String profileBackground = "$imgPath/profileBackground.png";
  static const String profile = "$imgPath/profileScreenIcon.png";
  static const String edit = "$imgPath/edit.svg";
  static const String payment = "$imgPath/payment.png";
  static const String howToUseThisApp = "$imgPath/howToUseThisApp.png";
  static const String notification2 = "$imgPath/notification2.png";
  static const String plus = "$imgPath/plus.png";

  //------------------------------ Payment Screen ---------------------
  static const String creditCard1 = "$imgPath/creditCard1.png";
  static const String creditCard2 = "$imgPath/creditCard2.png";
  static const String done = "$imgPath/done.svg";
  static const String pending = "$imgPath/pending.svg";
  static const String cancelled = "$imgPath/cancelled.svg";

  //--------------------------- Payment List Screen ---------------------
  static const String noPaymentBg = "$imgPath/noPaymentBg.png";

  //------------------------------ Checkout Screen ---------------------
  static const String rightArrow = "$imgPath/rightArrow.svg";
  static const String visa = "$imgPath/visaCard.svg";
  static const String close = "$imgPath/close.png";
  static const String whiteBackArrow = "$imgPath/white_back_arrow.png";

  //------------------------------ Select Card Screen ------------------
  static const String masterCard = "$imgPath/masterCard.svg";
  static const String googlePay = "$imgPath/googlePay.svg";
  static const String payPal = "$imgPath/payPal.svg";
  static const String applePay = "$imgPath/applePay.svg";
  static const String check = "$imgPath/check.svg";

  //-------------------------------- How to use app Screen -----------------------
  static const String request = "$imgPath/request.svg";
  static const String chatIcon = "$imgPath/chatIcon.svg";
  static const String dropdownIcon = "$imgPath/dropdown_icon.png";

  // -------------------------------- Chat screen ---------------------------------
  static const String rightAerrow = "$imgPath/keyboardRightAerrow.svg";
  static const String add = "$imgPath/add.svg";
  static const String whiteUser = "$imgPath/white_user.png";
  static const String back = "$imgPath/back.svg";
  static const String camera = "$imgPath/camera.svg";
  static const String defaultAvatar = "$imgPath/defaultAvatar.png";
  static const String defaultAvatarSvg = "$imgPath/defaultAvatar.svg";
  static const String noChatBg = "$imgPath/noChatBg.png";
  static const String trashCan = "$imgPath/trashcan.png";

  //------------------------------ Firebase----------------------------------------
  static const userCollection = 'staging_users';

  static String getPaymentStatusImage(String paymentStatus) {
    String image = clockWithBg;
    switch (paymentStatus) {
      case "done":
        image = tickWithBg;
        break;
      case "pending":
        image = clockWithBg;
        break;
      case "failed":
        image = closeWithBg;
        break;
      case "processor_declined":
        image = closeWithBg;
        break;
    }

    return image;
  }

  // card  images
  static String cardImage(Cards option) {
    String img = rentImage;

    switch (option) {
      case Cards.Visa_Card:
        img = visa;
        break;
      case Cards.Master_Card:
        img = masterCard;
        break;
      case Cards.Google_Pay:
        img = googlePay;
        break;
      case Cards.PayPal:
        img = payPal;
        break;
      case Cards.Apple_Pay:
        img = applePay;
        break;
    }
    return img;
  }

  // bottom bar images
  static String bottomBarImage(BottomBarOption option) {
    String img = rentImage;

    switch (option) {
      case BottomBarOption.Rent:
        img = rentImage;
        break;
      case BottomBarOption.Lend:
        img = lendImage;
        break;
      case BottomBarOption.Transactions:
        img = profileImage1;
        break;  
      case BottomBarOption.Chat:
        img = chatImage;
        break;
    }
    return img;
  }
}

//------------------------------Custom Fonts----------------------------//

class CustomFont {
  static const String metropolis = 'Metropolis';
  static const String redHatDisplay = "RedHatDisplay";
  static const String mochiyPopOne = "MochiyPopOne";
}

//------------------------------ Material Color------------------------//

const Color primaryColor = Color(0xFF02957D);

const int primary = 0xFF02957D;

const MaterialColor custMaterialPrimaryColor = MaterialColor(
  primary,
  <int, Color>{
    50: Color(primary),
    100: Color(primary),
    200: Color(primary),
    300: Color(primary),
    400: Color(primary),
    500: Color(primary),
    600: Color(primary),
    700: Color(primary),
    800: Color(primary),
    900: Color(primary),
  },
);

Color requestProgressColor = Colors.green.shade400;
const Color declineColor = Color(0xFF981E1E);
const Color custDarkBlue002346 = Color(0xFF002346);
const Color custLightGreenEAF0FC = Color(0xFFEAF0FC);
const Color custLightGreyD8D8D8 = Color(0xFFD8D8D8);
const Color custWhiteFFFFFF = Color(0xFFFFFFFF);
const Color custGreyA2A3A4 = Color(0xFFA2A3A4);
const Color custGrey7E7E7E = Color(0xFF7E7E7E);
const Color custGrey93A2B2 = Color(0xFF93A2B2);
const Color custGreen05A628 = Color(0xFF05A628);
const Color custGreen02957D = Color(0xFF02957D);
const Color custRedC81919 = Color(0xFFC81919);
const Color custRedFF3F50 = Color(0xFFFF3F50);
const Color custLightGreyEBEBEB = Color(0xFFEBEBEB);
const Color custLightBlue0091FF = Color(0xFF0091FF);
const Color custGrey = Color(0xFFD9D9D9);

// calender
const Color cust333333 = Color(0xFF333333);
const Color custF91942 = Color(0xFFF91942);
const Color custFAFAFA = Color(0xFFFAFAFA);
const Color custBBDDFF = Color(0xFFBBDDFF);
const Color cust6699FF = Color(0xFF6699FF);
const Color custAEAEAE = Color(0xFFAEAEAE);
const Color cust5A5A5A = Color(0xFF5A5A5A);
const Color custC6BC0 = Color(0xFF5C6BC0);
const Color cust9FA8DA = Color(0xFF9FA8DA);

const Color custE8E8E8 = Color(0xFFE8E8E8);
const Color custDBDEE3 = Color(0xFFDBDEE3);
const Color custDDE7FA = Color(0xFFDDE7FA);
const Color cust838485 = Color(0xFF838485);
const Color cust343C54 = Color(0xFF343C54);
const Color cust263238 = Color(0xFF263238);
const Color custF7F7F7 = Color(0xFFF7F7F7);
const Color custA4A4A4 = Color(0xFFA4A4A4);
const Color custC9CBCE = Color(0xFFC9CBCE);
const Color cust41AEF1 = Color(0xFF41AEF1);
const Color cust87919C = Color(0xFF87919C);
const Color cust00BEFF = Color(0xFF00BEFF);
const Color custFFA523 = Color(0xFFFFA523);
const Color cust000000 = Color(0xFF000000);
const Color custB5B5B5 = Color(0xFFB5B5B5);
const Color custE4E4E4 = Color(0xFFE4E4E4);
const Color cust88919C = Color(0xFF88919C);
const Color cust5F5F5F = Color(0xFF5F5F5F);
const Color cust77CB66 = Color(0xFF77CB66);
const Color custFF3F50 = Color(0xFFFF3F50);
const Color custF4F4F4 = Color(0xFFF4F4F4);

const Color custLighPinkFEEDFF = Color(0xFFFEEDFF);
const Color custBlack102339 = Color(0xFF102339);
Color custBlack102339WithOpacity = const Color(0xFF102339).withOpacity(0.5);
const Color custRedFC5A59 = Color(0xFFFC5A59);
const Color custOrangeE5714A = Color(0xFFE5714A);
const Color custBlue3AC5FF = Color(0xFF3AC5FF);

const Color custLightGreyF2F3F3 = Color(0xFFF2F3F3);

const Color custACACAC = Color(0xFFACACAC);
const Color cust111827 = Color(0xFF111827);

Color getPaymentStatusColor(String paymentStatus) {
  Color color = Color(0xFF64BC36);
  switch (paymentStatus) {
    case "done":
      color = Color(0xFF64BC36);
      break;
    case "pending":
      color = Color(0xFFFFBD11);

      break;
    case "failed":
      color = Color(0xFFFF3F50);
      break;

    case "processor_declined":
      color = Color(0xFFFF3F50);
      break;
  }

  return color;
}
