import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
   final String authToken;
   final String userId;

  Orders(this.authToken,this.userId,this._orders,);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> setAndAddOrders() async {
    final url = 'https://shopapp-df947.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (items) => CartItem(
                  id: items['id'],
                  price: items['price'],
                  quantity: items['quantity'],
                  title: items['title'],
                ),
              ).toList(),
        ),
      );
    });
    _orders=loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartItems, double total) async {
    final url = 'https://shopapp-df947.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartItems
              .map((cartitem) => {
                    'id': cartitem.id,
                    'title': cartitem.title,
                    'quantity': cartitem.quantity,
                    'price': cartitem.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartItems,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
