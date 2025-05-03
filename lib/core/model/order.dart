import 'menu_item.dart';

class Order {
  final String id;
  final String amount;
  final String orderStatus;
  final String paymentMethod;
  final String paymentStatus;
  final String userId;
  final String? driverId;
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
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.userId,
    required this.driverId,
    required this.requestForDriver,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.menuItems,
    required this.address,
    required this.business,
  });

  double get amountDouble => double.tryParse(amount) ?? 0.0;
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      amount: json['amount'],
      orderStatus: json['order_status'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      userId: json['user_id'],
      driverId: json['driver_id'],
      requestForDriver: json['request_for_driver'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      menuItems: (json['menu_items'] as List)
          .map((e) => MenuItem.fromJson(e))
          .toList(),
      address: Address.fromJson(json['address']),
      business: Business.fromJson(json['business']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'order_status': orderStatus,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'user_id': userId,
      'driver_id': driverId,
      'request_for_driver': requestForDriver,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'menu_items': menuItems.map((item) => item.toJson()).toList(),
      'address': address.toJson(),
      'business': business.toJson(),
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
  });

  double get latDouble => double.tryParse(lat) ?? 0.0;
  double get lngDouble => double.tryParse(long) ?? 0.0;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      lat: json['lat'],
      long: json['long'],
      name: json['name'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
  });
  double get latDouble => double.tryParse(latitude) ?? 0.0;
  double get lngDouble => double.tryParse(longitude) ?? 0.0;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      cuisine: json['cuisine'],
      banner: json['banner'],
      websiteUrl: json['website_url'],
      contactNo: json['contact_no'],
      description: json['description'],
      socialLinks: json['social_links'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isAvailable: json['is_available'],
      ownerId: json['owner_id'],
      opensAt: DateTime.parse(json['opens_at']),
      closesAt: DateTime.parse(json['closes_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
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
    };
  }
}
