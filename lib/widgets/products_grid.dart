import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final productsList = provider.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productsList.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (ctx) => productsList[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
