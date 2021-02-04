import 'package:flutter/material.dart';
import '../providers/orders_provider.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final Order _order;

  OrderItem(this._order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${_order.amount} total"),
            subtitle:
                Text(DateFormat("dd MM yyyy hh:mm").format(_order.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
