class CurrentOrderResponse {
  CurrentOrder? currentOrder;
  String? orderStatus;

  CurrentOrderResponse({this.currentOrder, this.orderStatus});

  factory CurrentOrderResponse.fromJson(Map<String, dynamic> json) {
    return CurrentOrderResponse(
      currentOrder: json['CurrentOrder'] != null
          ? CurrentOrder.fromJson(json['CurrentOrder'])
          : null,
      orderStatus: json['orderStatus']?.toString() ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'CurrentOrder': currentOrder?.toJson(),
        'orderStatus': orderStatus,
      };
}

class CurrentOrder {
  String? id;
  double? amount;
  Address? address;
  String? userId;
  Business? business;
  String? createdAt;
  String? deletedAt;
  List<MenuItems>? menuItems;
  String? updatedAt;
  bool? requestForDriver;

  CurrentOrder({
    this.id,
    this.amount,
    this.address,
    this.userId,
    this.business,
    this.createdAt,
    this.deletedAt,
    this.menuItems,
    this.updatedAt,
    this.requestForDriver,
  });

  factory CurrentOrder.fromJson(Map<String, dynamic> json) {
    return CurrentOrder(
      id: json['id']?.toString(),
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString()) ?? 0.0
          : null,
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      userId: json['user_id']?.toString(),
      business:
          json['business'] != null ? Business.fromJson(json['business']) : null,
      createdAt: json['created_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      menuItems: (json['menu_items'] as List<dynamic>? ?? [])
          .map((e) => MenuItems.fromJson(e))
          .toList(),
      updatedAt: json['updated_at']?.toString(),
      requestForDriver: json['request_for_driver'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'address': address?.toJson(),
        'user_id': userId,
        'business': business?.toJson(),
        'created_at': createdAt,
        'deleted_at': deletedAt,
        'menu_items': menuItems?.map((e) => e.toJson()).toList(),
        'updated_at': updatedAt,
        'request_for_driver': requestForDriver,
      };
}

class Address {
  String? id;
  double? lat;
  String? city;
  double? long;
  String? name;
  User? user;
  String? state;
  String? street;
  String? country;
  String? pincode;
  String? createdAt;
  String? updatedAt;

  Address({
    this.id,
    this.lat,
    this.city,
    this.long,
    this.name,
    this.user,
    this.state,
    this.street,
    this.country,
    this.pincode,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id']?.toString(),
      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString()) ?? 0.0
          : null,
      city: json['city']?.toString(),
      long: json['long'] != null
          ? double.tryParse(json['long'].toString()) ?? 0.0
          : null,
      name: json['name']?.toString(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      state: json['state']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      pincode: json['pincode']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lat': lat,
        'city': city,
        'long': long,
        'name': name,
        'user': user?.toJson(),
        'state': state,
        'street': street,
        'country': country,
        'pincode': pincode,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class User {
  String? id;
  String? name;
  String? email;
  String? mobno;
  String? pictureUrl;
  String? firstName;
  String? lastName;

  User(
      {this.id,
      this.name,
      this.email,
      this.mobno,
      this.pictureUrl,
      this.firstName,
      this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobno: json['mobno']?.toString(),
      pictureUrl: json['picture_url']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobno': mobno,
        'picture_url': pictureUrl,
        'first_name': firstName,
        'last_name': lastName,
      };
}

class Business {
  String? id;
  String? name;
  String? banner;
  BAddress? address;
  String? cuisine;
  double? latitude;
  String? opensAt;
  String? ownerId;
  String? closesAt;
  double? longitude;
  String? contactNo;
  String? createdAt;
  String? deletedAt;
  String? updatedAt;
  String? description;
  String? websiteUrl;
  bool? isAvailable;
  dynamic socialLinks;
  double? averageRating;

  Business({
    this.id,
    this.name,
    this.banner,
    this.address,
    this.cuisine,
    this.latitude,
    this.opensAt,
    this.ownerId,
    this.closesAt,
    this.longitude,
    this.contactNo,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
    this.description,
    this.websiteUrl,
    this.isAvailable,
    this.socialLinks,
    this.averageRating,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      banner: json['banner']?.toString(),
      address:
          json['address'] != null ? BAddress.fromJson(json['address']) : null,
      cuisine: json['cuisine']?.toString(),
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : null,
      opensAt: json['opens_at']?.toString(),
      ownerId: json['owner_id']?.toString(),
      closesAt: json['closes_at']?.toString(),
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : null,
      contactNo: json['contact_no']?.toString(),
      createdAt: json['created_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      description: json['description']?.toString(),
      websiteUrl: json['website_url']?.toString(),
      isAvailable: json['is_available'] ?? false,
      socialLinks: json['social_links'],
      averageRating: json['average_rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'banner': banner,
        'address': address?.toJson(),
        'cuisine': cuisine,
        'latitude': latitude,
        'opens_at': opensAt,
        'owner_id': ownerId,
        'closes_at': closesAt,
        'longitude': longitude,
        'contact_no': contactNo,
        'created_at': createdAt,
        'deleted_at': deletedAt,
        'updated_at': updatedAt,
        'description': description,
        'website_url': websiteUrl,
        'is_available': isAvailable,
        'social_links': socialLinks,
        'average_rating': averageRating,
      };
}

class BAddress {
  String? id;
  String? city;
  String? name;
  String? state;
  String? street;
  String? country;
  String? pincode;
  String? createdAt;
  String? updatedAt;

  BAddress({
    this.id,
    this.city,
    this.name,
    this.state,
    this.street,
    this.country,
    this.pincode,
    this.createdAt,
    this.updatedAt,
  });

  factory BAddress.fromJson(Map<String, dynamic> json) {
    return BAddress(
      id: json['id']?.toString(),
      city: json['city']?.toString(),
      name: json['name']?.toString(),
      state: json['state']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      pincode: json['pincode']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'city': city,
        'name': name,
        'state': state,
        'street': street,
        'country': country,
        'pincode': pincode,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class MenuItems {
  String? id;
  String? name;
  String? status;
  String? quantity;
  String? foodType;
  String? thumbnails;
  String? description;
  String? ingredients;

  MenuItems({
    this.id,
    this.name,
    this.status,
    this.quantity,
    this.foodType,
    this.thumbnails,
    this.description,
    this.ingredients,
  });

  factory MenuItems.fromJson(Map<String, dynamic> json) {
    return MenuItems(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      status: json['status']?.toString() ?? 'available',
      quantity: json['quantity']?.toString() ?? '0',
      foodType: json['food_type']?.toString() ?? '',
      thumbnails: json['thumbnails']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      ingredients: json['ingredients']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'quantity': quantity,
        'food_type': foodType,
        'thumbnails': thumbnails,
        'description': description,
        'ingredients': ingredients,
      };
}
