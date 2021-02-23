import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  static const String baseUrl =
      "https://fl-shop-d7c4e-default-rtdb.firebaseio.com/";

  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var response = await http.get(baseUrl + "orders.json");
    _orders = _mapResponseToOrdersList(response.body).reversed.toList();
    notifyListeners();
  }

  List<Order> _mapResponseToOrdersList(String responseBody) {
    // decode can't parse nested Map object
    final extractedData = json.decode(responseBody) as Map<String, dynamic>;
    if (extractedData == null) {
      return [];
    }
    return extractedData.keys
        .map((orderId) => Order(
            id: orderId,
            amount: extractedData[orderId]["amount"],
            dateTime: DateTime.parse(extractedData[orderId]["dateTime"]),
            products: (extractedData[orderId]["products"] as List<dynamic>)
                .map((productData) => CartItem(
                    id: productData["id"],
                    title: productData["title"],
                    quantity: productData["quantity"],
                    price: productData["price"]))
                .toList()))
        .toList();
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final DateTime dateTimeNow = DateTime.now();

    var response = await http.post(
      baseUrl + "orders.json",
      body: json.encode({
        "amount": total,
        "dateTime": dateTimeNow.toIso8601String(),
        "products": cartItems
            .map((item) => {
                  "id": item.id,
                  "title": item.title,
                  "quantity": item.quantity,
                  "price": item.price
                })
            .toList(),
      }),
    );
    _orders.add(Order(
        // auto-generated from firebase
        id: json.decode(response.body)["name"],
        dateTime: dateTimeNow,
        products: cartItems,
        amount: total));
    notifyListeners();
  }
}
