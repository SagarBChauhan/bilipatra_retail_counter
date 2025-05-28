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
