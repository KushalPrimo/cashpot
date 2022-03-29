

class Webservice
{
  //Staging Server
 // final apiUrl = "http://192.168.75.171:3009/api/users/"; 112.196.54.37:3009

  ///18.188.24.187:3009 ------>AWS
  ///3.130.228.241  ------->AWS After dynamic IP expire above
  ///112.196.54.37:3009  ------> PRIMOTECH
  final apiUrl = "http://3.130.228.241:3009/api/users/";
  final apiUrlcashpot = "http://3.130.228.241:3009/api/cashpot/";

  final imagePath = "http://3.130.228.241/cashpot/includes/uploads/";
  final apiUrlPayment = "http://3.130.228.241:3009/api/payments/";
  final notificationApiURL = "http://3.130.228.241:3009/api/notification/";
  final signup = "signup";
  final login = "login";
  final checkdublicate = "check-dublicate";
  final updateNumber = "update-number/";
  final verifyNumber = "verify-number";
  final getuserinfo = "get-user-info/";
  final editprofile = "edit-profile/";
  final uploadimage = "upload-image/";
  final forgetpassword = "forget-password/";
  final postUsersNumbers = "post-users-numbers";
  final createPot = "createPot";
  final createdwollacustomer = "create-dwolla-customer";
  final checkdwollacustomer = "check-dwolla-customer";
  final getIavToken = "get_iav_token";
  final getusercashpot = "get-user-cashpot";
  final cashpotinfo = "cashpot_info";
  final usersfundingsources = "users-funding-sources";
  final removefundingsource ="remove-funding-source";
  final getiavtokencard = "get-iav-token-card";
  final usertocashpot = "user-to-cashpot";
  final walletactivity = "wallet-activity";
  final potactivitylog = "pot-activity-log";
  final getuserpotactivitylog = "get-user-pot-activity-log";
  final removeCash = "remove-cash";
  final endPot = "end-pot";
  final changePassword = "change-password/";
  final potHistory = "pot-history";
  final potcreatoractivity = "pot-creator-activity";
  final wallettobank = "wallet-to-bank";
  final cashpotmembers = "cashpot-members";
  final removecashpotmember = "remove-cashpot-member";
  final getUsersNotification = "get-users-notification";
  final acceptpotrequest = "accept-pot-request";
  final notificationinfo = "notification_info";
  final declinepotrequest = "decline-pot-request";
  final deletenotifications = "delete-notifications";
  final getpotnotification = "get-pot-notification";
  final sendcash = "send-cash";
  final cashrequest = "cash-request";
  final editCashpot = "edit-cashpot";
  final creatorcashpotinfo = "creator-cashpot-info";
  final getnotificationpermissions = "get-notification-permissions";
  final updatenotificationpermissions = "update-notification-permissions";
  final transactionactivity = "transaction-activity";
  final cashpotregisterednumbers = "cashpot-registered-numbers";
  final leavepot = "leave-pot";
  final addmembers = "add-members";
  final feesinfo = "fees-info";
  final wallettopot = "wallet-to-pot";
  final notificationinfocashrequest = "notification_info_cash_request";
  final acceptcashrequest = "accept-cash-request";
  final declinecashrequest = "decline-cash-request";
  final opennotifications = "open-notifications";
  final cashouttowallet = "cash-out-to-wallet";
  final sendInvite = "send-invite";
  final feestranferfundinfo = "fees-tranfer-fund-info";
  final feesinfopottowallet = "fees-info-pot-to-wallet";
  final cashouttobank = "cash-out-to-bank";
  final getuserpotamount = "get-user-pot-amount";
  final searchusers = "search-users";
  final getnotificationbadges = "get-notification-badges";
  final OPEN_USER_NOTIFICATIONS =  "open-users-notifications";
}