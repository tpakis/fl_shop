import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
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
  var _isLoading = false;

  @override
  void initState() {
    // it wouldn't work without liste false, it would require hack with didChangeDependeciews
    // or Future.delayed(Duration.zero).then(use provider)
    _isLoading = true;
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

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
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
