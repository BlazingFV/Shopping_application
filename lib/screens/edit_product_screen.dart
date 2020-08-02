import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formGlobalKey = GlobalKey<FormState>();
  // final _textGlobalKey = GlobalKey();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener((_updateImageUrl));
  }

  _displaySnackBar(BuildContext context) {
    final snackbar = SnackBar(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 2,
          ),
          SizedBox(
            width: 4,
          ),
          Text('Adding your Product...'),
        ],
      ),
    );
    globalKey.currentState.showSnackBar(snackbar);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final idArg = ModalRoute.of(context).settings.arguments as String;
      if (idArg != null) {
        _editedProduct = Provider.of<ProductsProvider>(context).findById(idArg);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener((_updateImageUrl));
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formGlobalKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formGlobalKey.currentState.save();
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong...'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong...'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Okay'),
              ),
            ],
          ),
        );
      } //  finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();

    // print(_editedProduct.title);
    // print(_editedProduct.description);
    // print(_editedProduct.price);
    // print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? _displaySnackBar(context)
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formGlobalKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 4),
                                borderRadius: BorderRadius.circular(25),
                              )),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: value,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Provide a Value';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 4),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Provide a Price.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please Enter a Valid Number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please Enter a Number greater than zero.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 4),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Provide a Description.';
                            }
                            if (value.length < 10) {
                              return 'Should be at least 10 characters long!.';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.blue,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a Url!')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Image Url',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 4),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                  );
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Provide an image URL';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please Enter a vaild URl.';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please Enter a vaild image URl.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveForm,
        child: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}
