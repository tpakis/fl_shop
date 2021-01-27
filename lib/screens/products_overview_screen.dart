import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart_procider.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../data/products_dummy_data.dart';
import 'package:provider/provider.dart';

enum FilterOptions { FAVORITES, ALL }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final productsList = DUMMY_PRODUCTS;
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {});
              _showOnlyFavorites = selectedValue == FilterOptions.FAVORITES;
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only favorites"),
                value: FilterOptions.FAVORITES,
              ),
              PopupMenuItem(
                child: Text("All products"),
                value: FilterOptions.ALL,
              )
            ],
          ),
          // for efficiency the icon button doesn't need to refresh when the cart refreshes only the value,
          // so we pass the child next to the builder -named here ch- and the builder gets it so we can pass
          // it as child to the badge.
          Consumer<CartProvider>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
