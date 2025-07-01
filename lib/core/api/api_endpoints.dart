class ApiEndpoints {
  // Base paths
  static const _v1 = '/api/v1';

  //auth-service endpoints
  static const auth = '$_v1/auth-service';
  static const authHealth = '$auth/health';
  static const authLogin = '$auth/auth/login';
  static const authLogout = '$auth/auth/logout';
  static const authRefresh = '$auth/auth/refresh';
  static const authUserProfile = '$auth/users/profile';

  //delivery-service endpoints
  static const pickupCurrentLocation='$delivery/delivery/current-location';
  static const deliveryCurrentLocation='$delivery/delivery/current-location';
  static const authRegisterDeliveryUser = '$auth/partners/register';
  static const stripeOnboardingUrl = '$auth/partners/refresh-onboarding-url';

  static const delivery='$_v1/delivery-service';
  static const createPaymentIntent='$delivery/payouts/create-payment-intent';
  static String acceptOrderId(String orderId) => '$createPaymentIntent/$orderId';


  static const getAvailableOrders='$delivery/delivery/available-orders';
  static const getCurrentOrders='$delivery/delivery/current-orders';
  
  static const acceptDeliveryOrder='$delivery/delivery/accept';
  static String acceptOrderById(String orderId) => '$acceptDeliveryOrder/$orderId';


  static const getOrderWithSuccessfulPayout='$delivery/delivery/order-history';

  static const verifyOtpAtPickup='$delivery/delivery/verify-otp';
  static const checkOtpVerified='$delivery/delivery/order-otp-status';

}
