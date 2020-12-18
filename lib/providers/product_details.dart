import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'products.dart';
import '../models/httpException.dart';

class ProductDetails with ChangeNotifier {
  List<Products> _productDetails = [
    // Products(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imgUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Products(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Products(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Products(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;
  ProductDetails(this.authToken, this.userId, this._productDetails);
  // bool _isFavourite = false;

  // void changeFavState() {
  //   _isFavourite = true;
  //   notifyListeners();
  // }

  // void changeAllState() {
  //   _isFavourite = false;
  //   notifyListeners();
  // }

  List<Products> get listOfProduct {
    return [..._productDetails];
  }

  List<Products> get favOfproduct {
    return _productDetails.where((product) => product.isFavourite).toList();
  }

  Products findById(String id) {
    return _productDetails.firstWhere(
      (product) => product.id == id,
      orElse: () {
        return;
      },
    );
  }

  Future<void> updateProduct(String id, Products newProduct) async {
    final proIndex = _productDetails.indexWhere((element) => element.id == id);
    if (proIndex >= 0) {
      final url =
          'https://grocery-shop-de018-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'id': newProduct.id,
            'description': newProduct.description,
            'price': newProduct.price,
          }));

      _productDetails[proIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://grocery-shop-de018-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final productIndex =
        _productDetails.indexWhere((element) => element.id == id);
    var product = _productDetails[productIndex];
    //product that will get delete,fthe reason for getting  this product to restore if any error occurs.

    _productDetails.removeAt(productIndex); //remove from
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // erro occurs restoring the values
      _productDetails.insert(productIndex,
          product); //any error occurs re updated with same value in list
      notifyListeners();
      throw HttpException(message: 'Could not delete');
    }
    product = null;
  }

  Future<void> fetchsetProducts([bool value = false]) async {
    var filterUserLink = value ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://grocery-shop-de018-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterUserLink';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      //fetching deatils from userFav
      url =
          'https://grocery-shop-de018-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken';

      final favResponse = await http.get(url);
      final favResponseData = json.decode(favResponse.body);

      final List<Products> loadedProducts = [];
      extractedData.forEach((productKey, productData) {
        loadedProducts.add(Products(
            id: productKey,
            isFavourite: favResponseData == null
                ? false
                : favResponseData[productKey] ?? false,
            description: productData['description'],
            imgUrl: productData['imgUrl'],
            price: productData['price'],
            title: productData['title']));
      });
      _productDetails = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Products product) async {
    // String filterUser = "auth=$authToken&orderBy'creatorId'&equalTo'$userId'";
    final url =
        'https://grocery-shop-de018-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: json.encode({
            'creatorId': userId,
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imgUrl': product.imgUrl,
            // 'isFavourite': product.isFavourite,
          }));

      final newProduct = Products(
          id: json.decode(response.body)['name'],
          description: product.description,
          imgUrl: product.imgUrl,
          price: product.price,
          title: product.title);
      _productDetails.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
