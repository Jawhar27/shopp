import 'package:flutter/material.dart';
import 'package:shopp/providers/order.dart';
import 'package:intl/intl.dart';
import '../widgets/order_item.dart';

class ListOrders extends StatefulWidget {
  final OrderItem item;
  ListOrders(this.item);

  @override
  _ListOrdersState createState() => _ListOrdersState();
}

class _ListOrdersState extends State<ListOrders> {
  var isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
            height: isExpand
                ? (widget.item.orderedItemsTitles.length * 20 + 30).toDouble()
                : 70,
            child: ListTile(
              title: Text('\$${widget.item.totalAmount.toStringAsFixed(2)}'),
              subtitle:
                  Text(DateFormat('dd MM yyyy hh:mm').format(widget.item.date)),
              trailing: IconButton(
                icon: Icon(isExpand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    isExpand = !isExpand;
                  });
                },
              ),
            ),
          ),
          AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.linear,
              height: isExpand
                  ? (widget.item.orderedItemsTitles.length * 20 + 30).toDouble()
                  : 0,
              child: OrderItemList(widget.item.orderedItemsTitles)),
        ],
      ),
    );
  }
}
