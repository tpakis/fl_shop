import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/products_dummy_data.dart';
import '../models/product.dart';

// with -a mixin which is similar to Delegate pattern in Kotlin
class ProductsProvider with ChangeNotifier {
  // products.json is our name of the node which will be ether updated or created on the fly - realtime db (json file)
  static const String url = "https://fl-shop-d7c4e-default-rtdb.firebaseio.com/products.json";
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

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProduct(final Product product) {
    // then creates a new future, and we return the last then future
    return http
        .post(
      url,
      body: json.encode({
        "title": product.title,
        "description": product.description,
        "imageUrl": product.imageUrl,
        "price": product.price,
        // we need to store it per user in the future, temp solution
        "isFavorite": product.isFavorite
      }),
    )
        .catchError((error) {
      print(error);
      throw error;
    }).then((response) {
      final newProduct = Product(
          // add the id of the product created in firebase, as name
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _products.add(newProduct);
      notifyListeners();
    });
  }

  void deleteProductById(String productId) {
    _products.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  Future<void> addOrEditProduct(final Product newProduct) {
    final productIndex =
        _products.indexWhere((element) => element.id == newProduct.id);
    if (productIndex != -1) {
      _products[productIndex] = newProduct;
      notifyListeners();
      return Future.value();
    } else {
      return addProduct(newProduct);
    }
  }
}
