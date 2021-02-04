import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

class Order {
  final String id;
  final DateTime dateTime;
  final List<CartItem> products;
  final double amount;

  Order(
      {@required this.id,
      @required this.dateTime,
      @required this.products,
      @required this.amount});
}

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    final DateTime dateTimeNow = DateTime.now();
    _orders.add(Order(
        id: dateTimeNow.toString(),
        dateTime: dateTimeNow,
        products: cartItems,
        amount: total));
    notifyListeners();
  }
}
