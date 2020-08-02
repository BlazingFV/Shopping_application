import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/widgets/drawers_widget.dart';
import 'package:shopping_app/widgets/user_product_widget.dart';

import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .getAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: DrawersWidget(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () => _refresh(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productsdata, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, index) => Column(
                            children: <Widget>[
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: UserProductWidget(
                                  id: productsdata.items[index].id,
                                  title: productsdata.items[index].title,
                                  imageUrl: productsdata.items[index].imageUrl,
                                ),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                          itemCount: productsdata.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
