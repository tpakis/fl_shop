import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user_products";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // pushNamed, not pushReplacementNamed to add to stack and show back button
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.products.length,
          itemBuilder: (ctx, index) => Column(
            children: [
              UserProductItem(
                id: productsData.products[index].id,
                title: productsData.products[index].title,
                imageUrl: productsData.products[index].imageUrl,
                deleteProduct: () => productsData
                    .deleteProductById(productsData.products[index].id),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
