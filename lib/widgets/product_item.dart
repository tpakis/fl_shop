import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  Product _product;

  @override
  Widget build(BuildContext context) {
    _product = Provider.of<Product>(context);
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
          leading: IconButton(
            icon: (_product.isFavorite)
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            onPressed: () {
              _product.toggleFavoriteStatus();
            },
            color: Theme.of(context).accentColor,
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
