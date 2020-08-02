import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  final String iD;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItems(
      {this.iD, this.price, this.quantity, this.title, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want to remove the item from the cart ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(iD),
      background: Card(
        color: Theme.of(context).errorColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        child: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
            right: 20,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        elevation: 10,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FittedBox(child: Text('\$ $price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$ ${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
