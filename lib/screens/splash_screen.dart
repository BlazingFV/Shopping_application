import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: <Widget>[
        Center(child: CircularProgressIndicator(),),
        Text('Loading...'),
      ],
    ),);
  }
}