import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool _showOnlyFavorites;

  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final productsList = (_showOnlyFavorites) ? provider.favoriteItems : provider.products;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productsList.length,
      // this is the correct way for listviews that recycle, and the recommended
      // way for data that preexist and we don't instantiate
      // ChangeNotifierProvider auto disposes data so no memory leaks
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: productsList[i],
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
