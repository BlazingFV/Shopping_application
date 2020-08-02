import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/drawers_widget.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/orders_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: DrawersWidget(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).setAndAddOrders(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text('An error occured!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, index) =>
                        OrdersItem(orderData.orders[index]),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          }),
    );
  }
}

//  return  ListView.builder(
//       itemBuilder: (ctx, index) =>
//           OrdersItem(orderData.orders[index]),
//       itemCount: orderData.orders.length,
//     );;
