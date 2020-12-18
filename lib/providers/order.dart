import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopp/providers/cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> orderedItemsTitles;
  final double totalAmount;
  final DateTime date;

  OrderItem(
      {@required this.id,
      @required this.orderedItemsTitles,
      @required this.totalAmount,
      @required this.date});
}

class Order with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get orderItems {
    return [..._orderItems];
  }

  final String authToken;
  final String userId;
  Order(this._orderItems, this.authToken, this.userId);

  Future<void> addToOrderItems(List<CartItem> cartItem, double total) async {
    final url =
        'https://grocery-shop-de018-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.post(url,
        body: json.encode({
          'totalAmount': total,
          'date': DateTime.now().toIso8601String(),
          'orderedItemsTitles': cartItem
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
        }));

    _orderItems.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            orderedItemsTitles: cartItem,
            totalAmount: total,
            date: DateTime.now()));

    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url =
        'https://grocery-shop-de018-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final List<OrderItem> loadedList = [];
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedList.add(OrderItem(
          id: orderId,
          totalAmount: orderData['totalAmount'],
          date: DateTime.parse(orderData['date']),
          orderedItemsTitles: (orderData['orderedItemsTitles']
                  as List<dynamic>) //list of cart products
              .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']))
              .toList()));
    });
    _orderItems = loadedList.reversed.toList();
    notifyListeners();
  }
}
