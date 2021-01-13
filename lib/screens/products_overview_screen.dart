import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../data/products_dummy_data.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final productsList = DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: productsList.length,
        itemBuilder: (ctx, i) => ProductItem(productsList[i]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
      ),
    );
  }
}
