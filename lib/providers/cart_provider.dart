import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price
  });

}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingItem) =>
          CartItem(id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity + 1,
              price: existingItem.price));
    } else {
      _items.putIfAbsent(productId, () =>
          CartItem(id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItemByProductId(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeItemByCartItemId(String cartItemId) {
    _items.removeWhere((key, value) => value.id == cartItemId);
    notifyListeners();
  }

  void reduceQuantityOfCartItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId].quantity > 1) {
      _items.update(productId, (existingItem) =>
          CartItem(id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity - 1,
              price: existingItem.price));
    } else {
      removeItemByProductId(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalCartAmount {
    var sum = 0.0;

    _items.forEach((key, value) {
      sum += value.price * value.quantity;
    });
    return sum;
  }

  int get itemCount {
    return _items.length;
  }

}
