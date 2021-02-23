import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/order_item.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    // hack because context is not available on init state or Future.delayed(Duration.zero).then(use provider)
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<OrdersProvider>(context, listen: false)
          .fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (ctx, index) {
                return OrderItem(ordersData.orders[index]);
              },
            ),
    );
  }
}
