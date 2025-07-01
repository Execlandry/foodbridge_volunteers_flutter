class OrderHistory {
  final OrderDetails orderDetails;
  final String orderStatus;
  final PaymentDetails paymentDetails;

  OrderHistory({
    required this.orderDetails,
    required this.orderStatus,
    required this.paymentDetails,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        orderDetails: OrderDetails.fromJson(json["order_details"] ?? {}),
        orderStatus: json["order_status"] ?? '',
        paymentDetails: PaymentDetails.fromJson(json["payment_details"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "order_details": orderDetails.toJson(),
        "order_status": orderStatus,
        "payment_details": paymentDetails.toJson(),
      };
}

class OrderDetails {
  final String id;
  final String otp;
  final String amount;
  final Address address;
  final String userId;
  final Business business;
  final String createdAt;
  final String? deletedAt;
  final List<MenuItem> menuItems;
  final String updatedAt;
  final bool isOtpVerified;
  final bool requestForDriver;

  OrderDetails({
    required this.id,
    required this.otp,
    required this.amount,
    required this.address,
    required this.userId,
    required this.business,
    required this.createdAt,
    this.deletedAt,
    required this.menuItems,
    required this.updatedAt,
    required this.isOtpVerified,
    required this.requestForDriver,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        id: json["id"] ?? '',
        otp: json["otp"] ?? '',
        amount: json["amount"] ?? '0',
        address: Address.fromJson(json["address"] ?? {}),
        userId: json["user_id"] ?? '',
        business: Business.fromJson(json["business"] ?? {}),
        createdAt: json["created_at"] ?? '',
        deletedAt: json["deleted_at"],
        menuItems: List<MenuItem>.from(
            (json["menu_items"] ?? []).map((x) => MenuItem.fromJson(x))),
        updatedAt: json["updated_at"] ?? '',
        isOtpVerified: json["is_otp_verified"] ?? false,
        requestForDriver: json["request_for_driver"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "otp": otp,
        "amount": amount,
        "address": address.toJson(),
        "user_id": userId,
        "business": business.toJson(),
        "created_at": createdAt,
        "deleted_at": deletedAt,
        "menu_items": List<dynamic>.from(menuItems.map((x) => x.toJson())),
        "updated_at": updatedAt,
        "is_otp_verified": isOtpVerified,
        "request_for_driver": requestForDriver,
      };
}

class Address {
  final String id;
  final String lat;
  final String city;
  final String long;
  final String name;
  final User? user;
  final String state;
  final String street;
  final String country;
  final String pincode;
  final String createdAt;
  final String updatedAt;

  Address({
    required this.id,
    required this.lat,
    required this.city,
    required this.long,
    required this.name,
    this.user,
    required this.state,
    required this.street,
    required this.country,
    required this.pincode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"] ?? '',
        lat: json["lat"] ?? '0.0',
        city: json["city"] ?? '',
        long: json["long"] ?? '0.0',
        name: json["name"] ?? '',
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        state: json["state"] ?? '',
        street: json["street"] ?? '',
        country: json["country"] ?? '',
        pincode: json["pincode"] ?? '',
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "city": city,
        "long": long,
        "name": name,
        "user": user?.toJson(),
        "state": state,
        "street": street,
        "country": country,
        "pincode": pincode,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class User {
  final String id;
  final String name;
  final String email;
  final String mobno;
  final String lastName;
  final String firstName;
  final String? pictureUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobno,
    required this.lastName,
    required this.firstName,
    this.pictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        mobno: json["mobno"] ?? '',
        lastName: json["last_name"] ?? '',
        firstName: json["first_name"] ?? '',
        pictureUrl: json["picture_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobno": mobno,
        "last_name": lastName,
        "first_name": firstName,
        "picture_url": pictureUrl,
      };
}

class Business {
  final String id;
  final String name;
  final String banner;
  final Address address;
  final dynamic cuisine;
  final String latitude;
  final String opensAt;
  final String ownerId;
  final String closesAt;
  final String longitude;
  final String contactNo;
  final String createdAt;
  final String? deletedAt;
  final String updatedAt;
  final String description;
  final String? websiteUrl;
  final bool isAvailable;
  final dynamic socialLinks;
  final dynamic averageRating;

  Business({
    required this.id,
    required this.name,
    required this.banner,
    required this.address,
    this.cuisine,
    required this.latitude,
    required this.opensAt,
    required this.ownerId,
    required this.closesAt,
    required this.longitude,
    required this.contactNo,
    required this.createdAt,
    this.deletedAt,
    required this.updatedAt,
    required this.description,
    this.websiteUrl,
    required this.isAvailable,
    this.socialLinks,
    this.averageRating,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        banner: json["banner"] ?? '',
        address: Address.fromJson(json["address"] ?? {}),
        cuisine: json["cuisine"],
        latitude: json["latitude"] ?? '0.0',
        opensAt: json["opens_at"] ?? '',
        ownerId: json["owner_id"] ?? '',
        closesAt: json["closes_at"] ?? '',
        longitude: json["longitude"] ?? '0.0',
        contactNo: json["contact_no"] ?? '',
        createdAt: json["created_at"] ?? '',
        deletedAt: json["deleted_at"],
        updatedAt: json["updated_at"] ?? '',
        description: json["description"] ?? '',
        websiteUrl: json["website_url"],
        isAvailable: json["is_available"] ?? false,
        socialLinks: json["social_links"],
        averageRating: json["average_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "banner": banner,
        "address": address.toJson(),
        "cuisine": cuisine,
        "latitude": latitude,
        "opens_at": opensAt,
        "owner_id": ownerId,
        "closes_at": closesAt,
        "longitude": longitude,
        "contact_no": contactNo,
        "created_at": createdAt,
        "deleted_at": deletedAt,
        "updated_at": updatedAt,
        "description": description,
        "website_url": websiteUrl,
        "is_available": isAvailable,
        "social_links": socialLinks,
        "average_rating": averageRating,
      };
}

class MenuItem {
  final String id;
  final String name;
  final String status;
  final String quantity;
  final String foodType;
  final String thumbnails;
  final String description;
  final String ingredients;

  MenuItem({
    required this.id,
    required this.name,
    required this.status,
    required this.quantity,
    required this.foodType,
    required this.thumbnails,
    required this.description,
    required this.ingredients,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        status: json["status"] ?? 'available',
        quantity: json["quantity"] ?? '0',
        foodType: json["food_type"] ?? '',
        thumbnails: json["thumbnails"] ?? '',
        description: json["description"] ?? '',
        ingredients: json["ingredients"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "quantity": quantity,
        "food_type": foodType,
        "thumbnails": thumbnails,
        "description": description,
        "ingredients": ingredients,
      };
}

class PaymentDetails {
  final String amount;
  final String commission;
  final String netAmount;
  final String paymentMethod;
  final String stripePaymentIntentId;

  PaymentDetails({
    required this.amount,
    required this.commission,
    required this.netAmount,
    required this.paymentMethod,
    required this.stripePaymentIntentId,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        amount: json["amount"] ?? '0',
        commission: json["commission"] ?? '0',
        netAmount: json["net_amount"] ?? '0',
        paymentMethod: json["payment_method"] ?? '',
        stripePaymentIntentId: json["stripe_payment_intent_id"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "commission": commission,
        "net_amount": netAmount,
        "payment_method": paymentMethod,
        "stripe_payment_intent_id": stripePaymentIntentId,
      };
}