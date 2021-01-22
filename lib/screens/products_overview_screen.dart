import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../data/products_dummy_data.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final productsList = DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      body: ProductsGrid(),
    );
  }
}


