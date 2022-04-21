class Product {
  final String id;
  final String name;
  final int price;
  final String description;
  final String category;
  final String image;
  final String sellerId;
  final String sellerName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.sellerId,
    this.sellerName = '',
  });
}
