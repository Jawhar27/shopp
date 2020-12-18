//local widget because form affecting single wifget

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopp/providers/products.dart';

import '../providers/product_details.dart';

class EditUserProductScreen extends StatefulWidget {
  static const routeName = 'edit_userProduct_screen';

  @override
  _EditUserProductScreenState createState() => _EditUserProductScreenState();
}

class _EditUserProductScreenState extends State<EditUserProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imagePreviewFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imagePreviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var product =
      Products(id: null, description: '', imgUrl: '', price: 0, title: '');

  var initialVal = {'title': '', 'imgurl': '', 'price': '', 'description': ''};
  var _isInit = true;
  var isLoading = false;

  @override
  void initState() {
    _imagePreviewFocusNode.addListener(updateFocusImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      print(id);
      var getproduct =
          Provider.of<ProductDetails>(context, listen: false).findById(id);
      if (id != null) {
        product = getproduct;
        print(product.title);
        initialVal = {
          'title': product.title,
          'price': product.price.toString(),
          'imgUrl': '',
          'description': product.description
        };
        _imagePreviewController.text = product.imgUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void updateFocusImage() {
    if (!_imagePreviewFocusNode.hasFocus) {
      if (!_imagePreviewController.text.startsWith('http') &&
          !_imagePreviewController.text.startsWith('https')) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _imagePreviewFocusNode.removeListener(updateFocusImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imagePreviewController.dispose();

    super.dispose();
  }

  Future<void> saveFormDetails() async {
    final isvalid = _formKey.currentState.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState.save(); //when form saved loading stared
    setState(() {
      isLoading = true;
    });
    if (product.id != null) {
      await Provider.of<ProductDetails>(context, listen: false)
          .updateProduct(product.id, product);
    } else {
      try {
        await Provider.of<ProductDetails>(context, listen: false)
            .addProduct(product);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(
                    child: Text('ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            });
      }

      // finally {
      //   setState(() {
      //     isLoading = false; //after pop loading finished
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveFormDetails,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initialVal['title'],
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(fontSize: 15)),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please fill the Title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Products(
                            id: product.id,
                            isFavourite: product.isFavourite,
                            description: product.description,
                            imgUrl: product.imgUrl,
                            price: product.price,
                            title: value);
                      },
                    ),
                    TextFormField(
                      initialValue: initialVal['price'],
                      decoration: InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(fontSize: 15)),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter the value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'enter the proper value';
                        }
                        if (double.parse(value) <= 0) {
                          return 'enter the value that greater than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Products(
                            id: product.id,
                            isFavourite: product.isFavourite,
                            description: product.description,
                            imgUrl: product.imgUrl,
                            price: double.parse(value),
                            title: product.title);
                      },
                    ),
                    TextFormField(
                      initialValue: initialVal['description'],
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(fontSize: 15)),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter the description';
                        }
                        if (value.length < 10) {
                          return 'enter description greater than 10 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        product = Products(
                            id: product.id,
                            isFavourite: product.isFavourite,
                            description: value,
                            imgUrl: product.imgUrl,
                            price: product.price,
                            title: product.title);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            )),
                            //preview of user enteredImage
                            child: _imagePreviewController.text.isEmpty
                                ? Text('Enter the Image Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imagePreviewController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        //expanded---because row has unconstrained width,doent has boundaries that is why expanded used.
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imagePreviewController,
                            focusNode: _imagePreviewFocusNode,
                            onSaved: (value) {
                              product = Products(
                                  id: product.id,
                                  isFavourite: product.isFavourite,
                                  description: product.description,
                                  imgUrl: value,
                                  price: product.price,
                                  title: product.title);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'enter a image url';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'enter a valid url';
                              }
                              // if (!value.endsWith('png') &&
                              //     !value.endsWith('png') &&
                              //     !value.endsWith('png')) {
                              //   return 'entered url is not suitable for image';
                              // }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              saveFormDetails();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
