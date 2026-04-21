enum OrderStatus { pending, approved, rejected }

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imagePath;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePath,
  });
}

class Order {
  final String id;
  final List<FoodItem> items;
  final DateTime deliveryDate;
  final String customerName;
  final String phone;
  final String address;
  final String email;
  String? paymentMethod;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.deliveryDate,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.email,
    this.paymentMethod,
    this.status = OrderStatus.pending,
  });

  double get total => items.fold(0, (sum, item) => sum + item.price);
}
