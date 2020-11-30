import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  bool isFavourite;

  Products(
      {@required this.id,
      @required this.description,
      @required this.imgUrl,
      this.isFavourite = false,
      @required this.price,
      @required this.title});

  void toggleFav() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
