import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';

class UserProductWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductWidget({
    this.title,
    this.imageUrl,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 26.5,
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 25,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: Text('Are you Sure ?'),
                    content: Text('Do you want to delete this product ? '),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text(
                          'Confirm',
                        ),
                        onPressed: () async {
                          try {
                            await Provider.of<ProductsProvider>(context,
                                    listen: false)
                                .deleteProduct(id);
                            Navigator.pop(context);
                          } catch (error) {
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text('Deleting failed!',textAlign: TextAlign.center,),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
