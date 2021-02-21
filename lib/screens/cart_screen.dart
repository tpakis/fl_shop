import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../widgets/app_drawer.dart';
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
      drawer: AppDrawer(),
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
                      "\$${cart.totalCartAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: theme.primaryTextTheme.headline6.color),
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                  OrderButton(cart: cart, theme: theme),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.theme,
  }) : super(key: key);

  final CartProvider cart;
  final ThemeData theme;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      //with null the button is disabled by flutter automatically
      onPressed: (widget.cart.totalCartAmount <= 0 || _isLoading) ? null : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<OrdersProvider>(context, listen: false)
            .addOrder(
            widget.cart.items.values.toList(), widget.cart.totalCartAmount);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clearCart();
      },
      child: (_isLoading) ? CircularProgressIndicator() : Text(
        "Order Now",
        style: TextStyle(color: widget.theme.primaryColor),
      ),
    );
  }
}
