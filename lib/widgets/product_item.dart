import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the data only once
    Product product = Provider.of<Product>(context, listen: false);
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                  arguments: product.id);
            }),
        footer: GridTileBar(
          // same as Provider.of but it's a widget instead of data, so we can
          // use it in a widget tree, to update only parts of the tree when data
          // changes. This is a second observer which listens to changes regardless
          // of if we have a provider on root or not and if it listens or not.
          // Optimization, and fine control of changes.
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: (product.isFavorite)
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: Material(
            color: Colors.transparent,
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.title, product.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Item was added to the cart!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          cart.reduceQuantityOfCartItem(product.id);
                        },
                      ),
                    ),
                  );
                },
                color: Theme.of(context).accentColor),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
