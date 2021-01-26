import 'package:flutter/material.dart';
import '../data/products_dummy_data.dart';
import '../models/product.dart';

// with -a mixin which is similar to Delegate pattern in Kotlin
class ProductsProvider with ChangeNotifier {
  // backing private property
  final List<Product> _products = DUMMY_PRODUCTS;

  List<Product> get products {
    // returning new list to avoid mutatitng the original list, no mutableList like Kotlin
    return [..._products];
  }

  List<Product> get favoriteItems {
    // returning new list to avoid mutatitng the original list, no mutableList like Kotlin
    return _products.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  void addProduct(final Product product) {
    _products.add(product);
    notifyListeners();
  }
}