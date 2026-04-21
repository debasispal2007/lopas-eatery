import 'package:flutter/material.dart';
import '../models/order_model.dart';

class AppState extends ChangeNotifier {
  final List<FoodItem> _menu = [
    // Starters
    FoodItem(
      id: 's1',
      name: 'Begun Bhaja',
      description: 'Hand-carved eggplant, marinated in golden turmeric and sea salt, pan-seared to a tender perfection.',
      price: 4.50,
      category: 'Starters',
      imagePath: 'assets/images/begun_bhaja.png',
    ),
    FoodItem(
      id: 's2',
      name: 'Aloo Bhaja',
      description: 'Paper-thin potato matchsticks, double-fried for an addictive, artisanal crunch.',
      price: 3.50,
      category: 'Starters',
      imagePath: 'assets/images/aloo_bhaja.png',
    ),
    FoodItem(
      id: 's3',
      name: 'Peyaji',
      description: 'Crispy onion lace fritters infused with green chili and handmade chickpea flour.',
      price: 4.00,
      category: 'Starters',
      imagePath: 'assets/images/peyaji.jpg',
    ),
    FoodItem(
      id: 's4',
      name: 'Aloo Posto',
      description: 'Potatoes delicately coated in a creamy, stone-ground poppy seed paste—a rustic classic.',
      price: 5.50,
      category: 'Starters',
      imagePath: 'assets/images/aloo_posto.jpg',
    ),
    // Main Dishes
    FoodItem(
      id: 'm1',
      name: 'Kosha Mangsho',
      description: 'The crown jewel: tender mutton slow-cooked over hours in a dark, caramelized onion reduction.',
      price: 18.50,
      category: 'Main Dishes',
      imagePath: 'assets/images/kosha_mangsho.jpg',
    ),
    FoodItem(
      id: 'm2',
      name: 'Murgir Jhol',
      description: 'A light, nostalgic Sunday-style broth, slow-simmered with garden spices and tender potato chunks.',
      price: 12.50,
      category: 'Main Dishes',
      imagePath: 'assets/images/murgir_jhol.jpg',
    ),
    FoodItem(
      id: 'm3',
      name: 'Kosha Murgi',
      description: 'Semi-dry, rich chicken reduction where the meat is slow-cooked in its own spice-infused juices.',
      price: 13.50,
      category: 'Main Dishes',
      imagePath: 'assets/images/kosha_murgi.jpg',
    ),
    FoodItem(
      id: 'm4',
      name: 'Basanti Pulao',
      description: 'Golden, aromatic rice infused with saffron and ghee, studded with cashews and raisins.',
      price: 12.00,
      category: 'Main Dishes',
      imagePath: 'assets/images/basanti_pulao.jpg',
    ),
    FoodItem(
      id: 'm5',
      name: 'Shada Pulao',
      description: 'Fragrant white pulao, lightly tossed in ghee with whole cloves and cardamom.',
      price: 10.00,
      category: 'Main Dishes',
      imagePath: 'assets/images/shada_pulao.jpg',
    ),
    // Desserts
    FoodItem(
      id: 'd1',
      name: 'Aam Sandesh',
      description: 'Hand-molded chhena sweet infused with the essence of sun-ripened Alfonso mangoes.',
      price: 4.50,
      category: 'Desserts',
      imagePath: 'assets/images/aam_sandesh.jpg',
    ),
    FoodItem(
      id: 'd2',
      name: 'Kesar Sandesh',
      description: 'A regal treat of fine chhena scented with Kashmiri saffron and topped with pistachios.',
      price: 4.50,
      category: 'Desserts',
      imagePath: 'assets/images/kesar_sandesh.jpg',
    ),
    FoodItem(
      id: 'd3',
      name: 'Nolen Gur Sandesh',
      description: 'A seasonal winter masterpiece featuring the deep, smoky caramel notes of date palm jaggery.',
      price: 3.00,
      category: 'Desserts',
      imagePath: 'assets/images/nolen_gur_sandesh.jpg',
    ),
    FoodItem(
      id: 'd4',
      name: 'Plain / Kacha Golla',
      description: 'Soft, melt-in-the-mouth spheres of fresh chhena, lightly sweetened for a pure dairy finish.',
      price: 2.50,
      category: 'Desserts',
      imagePath: 'assets/images/kacha_golla.jpg',
    ),
    FoodItem(
      id: 'd5',
      name: 'Payesh',
      description: 'A rich, slow-cooked masterpiece where fragrant Gobindobhog rice grains swim in a thick, sweetened milk reduction, delivering a perfect balance of delicate texture and creamy indulgence.',
      price: 6.00,
      category: 'Desserts',
      imagePath: 'assets/images/payesh.jpg',
    ),
    FoodItem(
      id: 'd6',
      name: 'Bhapa Sandesh',
      description: 'Exquisitely steamed chhena with condensed milk, offering a delicate, cheesecake-like texture.',
      price: 3.50,
      category: 'Desserts',
      imagePath: 'assets/images/bhapa_sandesh.jpg',
    ),
  ];

  List<FoodItem> get menu => _menu;

  final List<FoodItem> _cart = [];
  List<FoodItem> get cart => _cart;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  final List<Order> _orders = [];
  List<Order> get orders => _orders;

  void addToCart(FoodItem item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(FoodItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void placeOrder(String name, String phone, String address, String email) {
    if (_cart.isEmpty || _selectedDate == null) return;

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(_cart),
      deliveryDate: _selectedDate!,
      customerName: name,
      phone: phone,
      address: address,
      email: email,
    );

    _orders.add(newOrder);
    _cart.clear();
    _selectedDate = null;
    notifyListeners();
  }

  void setPaymentMethod(String orderId, String method) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].paymentMethod = method;
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      notifyListeners();
    }
  }
}
