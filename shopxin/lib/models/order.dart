class Order {
  final String id;
  final DateTime dateTime;
  final List<dynamic> pIds;
  final List<dynamic> q;

  Order({
    required this.id,
    required this.dateTime,
    required this.q,
    required this.pIds,
  });
}
