import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "PRODUTC_DETAILS";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // don't listen just get current value
    final provider = Provider.of<ProductsProvider>(context, listen: false);
    final product = provider.findById(productId);

    return Scaffold(
      appBar: AppBar(title: Text(product.title),),
    );
  }
}
