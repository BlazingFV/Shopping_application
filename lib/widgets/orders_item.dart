import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrdersItem extends StatefulWidget {
  final ord.OrderItem order;
  OrdersItem(this.order);

  @override
  _OrdersItemState createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        '\$${widget.order.amount}',
                      ),
                      subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                          .format(widget.order.dateTime)),
                      trailing: IconButton(
                          icon: Icon(_expanded
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          }),
                    ),
                    if (_expanded)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(4),
                        height: _expanded
                            ? min(
                                widget.order.products.length * 20.0 + 35.0, 180)
                            : 0,
                        child: ListView(
                          children: widget.order.products
                              .map((product) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        product.title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${product.quantity}x\$${product.price}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
