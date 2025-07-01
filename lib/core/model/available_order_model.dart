class AvailableOrder {
  final String id;
  final String orderId;
  final Order order;
  final String? orderStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  AvailableOrder({
    required this.id,
    required this.orderId,
    required this.order,
    this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AvailableOrder.fromJson(Map<String, dynamic> json) {
    return AvailableOrder(
      id: json['id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      order: Order.fromJson(json['order'] as Map<String, dynamic>),
      orderStatus: json['order_status'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'order': order.toJson(),
      'order_status': orderStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Order {
  final String id;
  final String amount;
  final String userId;
  final bool requestForDriver;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<MenuItem> menuItems;
  final Address address;
  final Business business;

  Order({
    required this.id,
    required this.amount,
    required this.userId,
    required this.requestForDriver,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.menuItems,
    required this.address,
    required this.business,
  });

  double get amountDouble => double.tryParse(amount) ?? 0.0;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String? ?? '',
      amount: json['amount'] as String? ?? '0.00',
      userId: json['user_id'] as String? ?? '',
      requestForDriver: json['request_for_driver'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toString()),
      deletedAt: json['deleted_at'] != null && json['deleted_at'].toString().isNotEmpty
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      menuItems: (json['menu_items'] as List? ?? [])
          .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'user_id': userId,
    'request_for_driver': requestForDriver,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'menu_items': menuItems.map((item) => item.toJson()).toList(),
    'address': address.toJson(),
    'business': business.toJson(),
  };
}

class User {
  final String id;
  final String name;
  final String email;
  final String mobno;
  final String firstName;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobno,
    required this.firstName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobno: json['mobno'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobno': mobno,
      'first_name': firstName,
    };
  }
}

class Address {
  final String id;
  final String lat;
  final String long;
  final String name;
  final String street;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;

  Address({
    required this.id,
    required this.lat,
    required this.long,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  double get latDouble => double.tryParse(lat) ?? 0.0;
  double get lngDouble => double.tryParse(long) ?? 0.0;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String? ?? '',
      lat: json['lat'] as String? ?? '0.0',
      long: json['long'] as String? ?? '0.0',
      name: json['name'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toString()),
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'long': long,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}

class Business {
  final String id;
  final String name;
  final String? cuisine;
  final String? banner;
  final String? websiteUrl;
  final String contactNo;
  final String? description;
  final String? socialLinks;
  final String latitude;
  final String longitude;
  final bool isAvailable;
  final String ownerId;
  final DateTime opensAt;
  final DateTime closesAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Address address;
  final double? averageRating;

  Business({
    required this.id,
    required this.name,
    this.cuisine,
    this.banner,
    this.websiteUrl,
    required this.contactNo,
    this.description,
    this.socialLinks,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    required this.ownerId,
    required this.opensAt,
    required this.closesAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.address,
    this.averageRating,
  });

  double get latDouble => double.tryParse(latitude) ?? 0.0;
  double get lngDouble => double.tryParse(longitude) ?? 0.0;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      cuisine: json['cuisine'] as String?,
      banner: json['banner'] as String?,
      websiteUrl: json['website_url'] as String?,
      contactNo: json['contact_no'] as String? ?? '',
      description: json['description'] as String?,
      socialLinks: json['social_links'] as String?,
      latitude: json['latitude'] as String? ?? '0.0',
      longitude: json['longitude'] as String? ?? '0.0',
      isAvailable: json['is_available'] as bool? ?? false,
      ownerId: json['owner_id'] as String? ?? '',
      opensAt: DateTime.parse(json['opens_at'] as String? ?? DateTime.now().toString()),
      closesAt: DateTime.parse(json['closes_at'] as String? ?? DateTime.now().toString()),
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toString()),
      deletedAt: json['deleted_at'] != null && json['deleted_at'].toString().isNotEmpty
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      averageRating: (json['average_rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'banner': banner,
      'website_url': websiteUrl,
      'contact_no': contactNo,
      'description': description,
      'social_links': socialLinks,
      'latitude': latitude,
      'longitude': longitude,
      'is_available': isAvailable,
      'owner_id': ownerId,
      'opens_at': opensAt.toIso8601String(),
      'closes_at': closesAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'address': address.toJson(),
      'average_rating': averageRating,
    };
  }
}

class MenuItem {
  final String id;
  final String name;
  final String quantity;
  final String foodType;
  final String thumbnails;
  final String status;
  final String description;
  final String ingredients;

  MenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.foodType,
    required this.thumbnails,
    required this.status,
    required this.description,
    required this.ingredients,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      foodType: json['food_type'] as String? ?? '',
      thumbnails: json['thumbnails'] as String? ?? '',
      status: json['status'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ingredients: json['ingredients'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'food_type': foodType,
      'thumbnails': thumbnails,
      'status': status,
      'description': description,
      'ingredients': ingredients,
    };
  }
}