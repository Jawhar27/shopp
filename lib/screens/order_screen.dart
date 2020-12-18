import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/widgets/listOrders_item.dart';

import '../providers/order.dart';
import '../widgets/drawer.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isload = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isload = true;
      });
      await Provider.of<Order>(context, listen: false).fetchOrders();

      setState(() {
        _isload = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context).orderItems;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: _isload
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: order.length,
              itemBuilder: (context, index) {
                return ListOrders(order[index]);
                // Container(
                //   child: ListTile(
                //     title: Text('\$${order[index].totalAmount}'),
                //     subtitle: Text(
                //         DateFormat('dd MM yyyy hh:mm').format(order[index].date)),
                //     trailing: IconButton(
                //       icon: Icon(isExpand ? Icons.expand_less : Icons.expand_more),
                //       onPressed: () {
                //         setState(() {
                //           isExpand = !isExpand;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                //
              },
            ),
    );
  }
}
