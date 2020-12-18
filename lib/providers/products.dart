import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> toggleFav(String authToken, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://grocery-shop-de018-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken';

    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));

      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
