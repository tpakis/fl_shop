import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/order_item.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';


class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders"),),
      body: ListView.builder(itemCount: ordersData.orders.length,itemBuilder: (ctx, index) {
        return OrderItem(ordersData.orders[index]);
      },),
    );
  }
}
