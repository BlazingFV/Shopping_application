import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_exceptions.dart';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/08/26/21/49/jeans-428614_960_720.jpg',
    )
  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userID;
  ProductsProvider(
    this.authToken,
    this.userID,
    this._items,
  );

  List<Product> get favItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }
  // void showFavoritesOnly(){
  //   _showFavoritesOnly=true;
  //   notifyListeners();
  // }
  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> getAndSetProducts([bool filterByUser= false]) async {
    final filterString= filterByUser? 'orderBy="creatorId"&equalTo="$userID"':'';
    var url =
        'https://shopapp-df947.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shopapp-df947.firebaseio.com/userFavorites/$userID.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((productId, productData) {
        loadedProduct.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp-df947.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userID,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct); //insert newProduct at the start of the list...
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url =
          'https://shopapp-df947.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
              // 'isFavorite': newProduct.isFavorite,
            }));
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopapp-df947.firebaseio.com/products/$id.json?auth=$authToken';
    final exisitingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var exisitingProduct = _items[exisitingProductIndex];
    _items.removeAt(exisitingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(exisitingProductIndex, exisitingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    exisitingProduct = null;
  }
}
