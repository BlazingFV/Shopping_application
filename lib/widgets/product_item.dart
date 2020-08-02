import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false);
    Widget changeIconButtonColor() {
      if (product.isFavorite) {
        return IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: () => product.toggleFavoriteStatus(
            authToken.token,
            authToken.userId,
          ),
        );
      } else {
        return IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () => product.toggleFavoriteStatus(
            authToken.token,
            authToken.userId,
          ),
        );
      }
      // IconButton(
      //           icon: Icon(
      //             product.isFavorite ? Icons.favorite : Icons.favorite_border,
      //             color: Colors.red,
      //           ),
      //           onPressed: () {
      //             product.toggleFavoriteStatus();
      //           },
      //         ),
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, _) => changeIconButtonColor(),
            ),
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added item to cart!'),
                    duration: Duration(seconds: 4),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                        print('....');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailsScreen.routeName,
                  arguments: product.id,
                );
              },
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ));
  }
}
