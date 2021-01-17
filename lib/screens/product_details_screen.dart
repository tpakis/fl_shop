import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "PRODUTC_DETAILS";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text("adsa"),),
    );
  }
}
