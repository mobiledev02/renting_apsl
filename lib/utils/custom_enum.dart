// ignore_for_file: constant_identifier_names

enum AuthType {
  Login,
  SignUp,
  OTP,
  resentOTP,
  ForgotPassword,
  ChangePassword,
  UpdateProfile,
  SetFcmToken,
  Logout,
  DeleteAccount,
  TermsAndCondition,
  PrivacyPolicy,
  None,
}

// enum FriendStatus {
//   Add,
//   Added,
//   Invite,
// }

enum BottomBarOption {
  Rent,
  Lend,
  Transactions,
  Chat,
}

enum SideMenuAppBarOption {
  My_Events,
  My_Requests,
  My_Friends,
}

enum ServiceType {
  Hourly,
  Day,
  Rented,
}

enum ItemAndServiceStatus {
  Rented,
  Available,
}

enum ItemOrService {
  item,
  service,
}

enum FilterMenu { service, item }



enum PickImageOption {
  camera,
  gallery,
}

enum Cards {
  Visa_Card,
  Master_Card,
  Google_Pay,
  PayPal,
  Apple_Pay,
}

enum ChatMessageStatus {
  Sender,
  Receiver,
}

enum EventType {
  Post,
  Request,
}

// enum IdentityGender {
//   Male,
//   Female,
// }

enum InterestedGender {
  Everyone,
  Women,
  Men,
}

enum CrudOperation {
  Create,
  Read,
  Update,
  Delete,
}

enum ScreenType {
  My_friend,
  Add_Friend_to_Event,
  Invite_Friend,
  All_Contacts,
  Friend_in_Attendance,
  None
}

enum CreateUpdateEventsScreenType { Create, Update }

enum CreateUpdateRequestScreenType { Create, Update }

enum DashboardBoardEventyListType {
  TodaysList,
  BrowseAllEvents,
  EventByEventType,

  None
}

enum MessageType {
  Text,
  Image,
  File,
  AdminB,  /// for both lender and renter
  AdminS,  /// specific for lender or renter
  ItemRequest,
  DateUpdate,
}

/// used in question of returning item in chat
enum LendingItemReturnStatus {
  OnTimeWithoutDamage,
  NotOnTime,
  OnTimeWithDamage,
}

/// used in the question for renter after paying and renting in chat
enum RentingItemStatus {
  Good,
  Damaged
}

///describes the state of the request object at the top of chat screen
enum ItemRequestStatus {
  Sent,
  LenderAccepted,
  LenderDeclined,
  Rented,
  RenterRejected,
  RenterObtained,
  LenderCompleted,
  LenderDisputed,
  Completed,
  DisputeResolved
}

/// job offer enum

enum OfferStatus {
  None,
  Pending,
  Accepted,
  Rejected,
  Hired,
  Logged,
  Disputed,
  Completed,
}

