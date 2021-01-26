import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../data/products_dummy_data.dart';

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
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
