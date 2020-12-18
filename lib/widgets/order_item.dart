import 'package:flutter/material.dart';

import '../providers/cart.dart';

class OrderItemList extends StatelessWidget {
  final List<CartItem> orderList;
  OrderItemList(this.orderList);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
      height: 100,
      child: ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          return Text(
            orderList[index].title +
                '-' +
                'x' +
                orderList[index].quantity.toString(),
            style: TextStyle(fontSize: 15),
          );
        },
      ),
    );
  }
}
