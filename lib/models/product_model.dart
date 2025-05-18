class Product {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['images'].isNotEmpty ? json['images'][0]['src'] : '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}
