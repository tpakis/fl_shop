import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    // not super efficient will rebuild everything
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total: ",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${cart.totalCartAmount}",
                      style: TextStyle(
                          color: theme.primaryTextTheme.headline6.color),
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Order Now",
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, itemIndex) {
                final CartItem item = cart.items.values.toList()[itemIndex];
                return CartListItem(
                    item.id, item.price, item.quantity, item.title);
              },
            ),
          ),
        ],
      ),
    );
  }
}
