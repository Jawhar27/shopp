import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class CartItem {
  final String title;
  final double price;
  final int quantity;
  final String id;
  CartItem(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
//cart items
  Map<String, CartItem> get cartItems {
    return {..._items};
  }

  double get totalAmountForCarts {
    double total = 0;
    _items.forEach((key, cartItem) {
      total = total + (cartItem.price * cartItem.quantity);
    });
    return total;
  }

  void addCartItems(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1,
              title: existingCartItem.title));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    }
    notifyListeners();
  }

  int get cartMapLength {
    return _items.length;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      //no items then return
      return;
    }
    if (_items[productId].quantity > 1) {
      //more than 1 item so reduce one
      _items.update(
          productId,
          (item) => CartItem(
              id: item.id,
              price: item.price,
              quantity: item.quantity - 1,
              title: item.title));
    } else {
      _items.remove(productId); //only one item remove that map item
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
