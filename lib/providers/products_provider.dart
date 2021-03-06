import 'package:flutter/material.dart';
import '../models/HttpException.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

// with -a mixin which is similar to Delegate pattern in Kotlin
class ProductsProvider with ChangeNotifier {
  // products.json is our name of the node which will be ether updated or created on the fly - realtime db (json file)
  static const String baseUrl =
      "https://fl-shop-d7c4e-default-rtdb.firebaseio.com/";

  // backing private property
  List<Product> _products = [];

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
      final response = await http.get(baseUrl + "/products.json");
      _products = mapResponseToProductsList(response.body);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  List<Product> mapResponseToProductsList(String responseBody) {
    // decode can't parse nested Map object
    final extractedData = json.decode(responseBody) as Map<String, dynamic>;
    if (extractedData == null) {
      return [];
    }
    return extractedData.keys
        .map((productId) => Product(
            id: productId,
            title: extractedData[productId]["title"],
            description: extractedData[productId]["description"],
            price: extractedData[productId]["price"],
            imageUrl: extractedData[productId]["imageUrl"]))
        .toList();
  }

  Future<void> addProduct(final Product product) {
    // then creates a new future, and we return the last then future
    return http
        .post(
      baseUrl + "/products.json",
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

  Future<void> deleteProductById(String productId) async {
    var response = await http.delete(baseUrl + "products/$productId.js");
    if (response.statusCode < 400) {
      _products.removeWhere((element) => element.id == productId);
      notifyListeners();
    } else {
      throw HttpException("Error while deleting product");
    }
  }

  Future<void> addOrEditProduct(final Product newProduct) async {
    final productIndex =
        _products.indexWhere((element) => element.id == newProduct.id);
    if (productIndex != -1) {
      await http
          .patch(
          baseUrl + "products/${newProduct.id}.json",
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price
          }));
      _products[productIndex] = newProduct;
      notifyListeners();
    } else {
      return addProduct(newProduct);
    }
  }
}
