import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/widgets/drawers_widget.dart';

import 'package:shopping_app/widgets/productsgrid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).getAndSetProducts();// wont work unless listen : is false.
    //  Future.delayed(Duration.zero).then((_) => Provider.of<ProductsProvider>(context).getAndSetProducts());
    // would work but not the best practice ...
    super.initState();
  }

  // _displaySnackBar(BuildContext context) {
  //   final snackbar = SnackBar(
  //     content: Row(
  //       children: <Widget>[
  //         CircularProgressIndicator(
  //           valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
  //           strokeWidth: 2,
  //         ),
  //         SizedBox(
  //           width: 4,
  //         ),
  //         Text('Adding your Product...'),
  //       ],
  //     ),
  //   );
  //   globalKey.currentState.showSnackBar(snackbar);
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductsProvider>(context).getAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('My Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              color: Colors.red,
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                }),
          ),
        ],
        title: Text('ShopApp'),
      ),
      drawer: DrawersWidget(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavoritesOnly),
    );
  }
}
