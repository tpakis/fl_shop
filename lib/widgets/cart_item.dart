import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartListItem extends StatelessWidget {
  final String _id;
  final double _price;
  final int _quantity;
  final String _title;

  CartListItem(this._id, this._price, this._quantity, this._title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        // show dialog returns a future when it's removed - pop-ed! So we can pop
        // it and pass the return value in the pop method as parameter
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure?"),
                  content:
                      Text("Do you want to remove the item from the cart?"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text("No"),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text("Yes"),
                    ),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false)
            .removeItemByCartItemId(_id);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(
                  child: Text("\$$_price"),
                ),
              ),
            ),
            title: Text(_title),
            subtitle: Text("Total: \$${_price * _quantity}"),
            trailing: Text("$_quantity x"),
          ),
        ),
      ),
    );
  }
}
