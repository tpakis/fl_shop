import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  Product _product;

  @override
  Widget build(BuildContext context) {
    // Get the data only once
    _product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            child: Image.network(_product.imageUrl, fit: BoxFit.cover),
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                  arguments: _product.id);
            }),
        footer: GridTileBar(
          // same as Provider.of but it's a widget instead of data, so we can
          // use it in a widget tree, to update only parts of the tree when data
          // changes. This is a second observer which listens to changes regardless
          // of if we have a provider on root or not and if it listens or not. 
          // Optimization, and fine control of changes.
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: (_product.isFavorite)
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                _product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).accentColor),
          backgroundColor: Colors.black87,
          title: Text(
            _product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
