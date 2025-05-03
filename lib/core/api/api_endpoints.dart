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
  static const authRegisterDeliveryUser = '$auth/partners/register';

  static const delivery='$_v1/delivery-service';
  static const getAvailableOrders='$delivery/delivery/available-orders';

  static const cart = '$_v1/cart-service';
  static const business = '$_v1/business-service';
  static const files = '$_v1/files-service';
  static const payment = '$_v1/payment-service';

  // Delivery endpoints
  // static const deliveryHealth = '$delivery/health';

  // etc...
}
