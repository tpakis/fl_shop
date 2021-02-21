import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  String get productUrl {
    return "https://fl-shop-d7c4e-default-rtdb.firebaseio.com/products/$id.json";
  }

  Product(
      {@required this.id, @required this.title, @required this.description, @required this.price, @required this.imageUrl, this.isFavorite = false});

  void _setFavoriteState(bool isFavorite) {
    this.isFavorite = isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    // optimistically update value
    final previousState = isFavorite;
    _setFavoriteState(!isFavorite);
    try {
      var response = await http.patch(productUrl, body: json.encode({"isFavorite": isFavorite}));
      // http package throws error only for get and post, not for patch, delete, so we manually check the
      // response code for errors.
      if (response.statusCode >= 400) {
        _setFavoriteState(previousState);
      }
    // other network issues might occur though which will throw errors so we catch them also
    } catch (error) {
      _setFavoriteState(previousState);
    }
  }
}

