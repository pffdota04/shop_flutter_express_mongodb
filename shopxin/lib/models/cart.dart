class CartItem {
  final String id;
  final String title;
  final String image;
  final int price;
  final int quantity;

  CartItem({
    required this.id,
    required this.price,
    required this.image,
    required this.quantity,
    required this.title,
  });
}
