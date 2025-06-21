class ProductModel {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String image; // new field

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image, // include in constructor
    this.quantity = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  ProductModel copyWith({
    int? quantity,
    String? image,
  }) {
    return ProductModel(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}

class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final double discountPrice;
  final String description;
  final String weight;
  final String manufactureBy;
  final DateTime productMfd;
  final DateTime productExpiryDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.discountPrice,
    required this.description,
    required this.weight,
    required this.manufactureBy,
    required this.productMfd,
    required this.productExpiryDate,
    required this.isActive,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
      image: json['product_image'],
      price: (json['product_price'] as num).toDouble(),
      discountPrice: (json['product_discount_price'] as num).toDouble(),
      description: json['product_description'],
      weight: json['product_weight'],
      manufactureBy: json['manufacture_by'],
      productMfd: DateTime.parse(json['product_mfd']),
      productExpiryDate: DateTime.parse(json['product_expiry_date']),
      isActive: json['is_active'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      lastUpdatedAt: DateTime.parse(json['last_updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'product_name': name,
      'product_image': image,
      'product_price': price,
      'product_discount_price': discountPrice,
      'product_description': description,
      'product_weight': weight,
      'manufacture_by': manufactureBy,
      'product_mfd': productMfd.toIso8601String(),
      'product_expiry_date': productExpiryDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'last_updated_at': lastUpdatedAt.toIso8601String(),
    };
  }
}

class ProductListResponse {
  final int flag;
  final int code;
  final String message;
  final List<Product> products;
  final int count;

  ProductListResponse({
    required this.flag,
    required this.code,
    required this.message,
    required this.products,
    required this.count,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      flag: json['flag'],
      code: json['code'],
      message: json['message'],
      products: List<Product>.from(json['data']['result'].map((p) => Product.fromJson(p))),
      count: json['data']['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flag': flag,
      'code': code,
      'message': message,
      'data': {
        'result': products.map((p) => p.toJson()).toList(),
        'count': count,
      },
    };
  }
}

