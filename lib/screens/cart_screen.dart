import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double total = Provider.of<Cart>(context).totalAmountForCarts;
    final Map<String, CartItem> cartItems =
        Provider.of<Cart>(context).cartItems;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Total'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Chip(
              label: Text(
                'Total Amount',
                style: TextStyle(fontSize: 25, color: Colors.blue),
              ),
            ),
            Text('$total'),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String key = cartItems.keys.elementAt(index);
                  return Dismissible(
                    onDismissed: (direction) {
                      Provider.of<Cart>(context, listen: false)
                          .removeItem(cartItems.keys.toList()[index]);
                    },
                    key: ValueKey(cartItems[key].id),
                    background: Container(
                      color: Theme.of(context).errorColor,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 40,
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Are you Sure'),
                              content: Text('Do you want to remove the item ?'),
                              actions: [
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                )
                              ],
                            );
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      color: Colors.yellow,
                      child: ListTile(
                        trailing: CircleAvatar(
                          child: FittedBox(
                              child: Text(cartItems[key].price.toString())),
                        ),
                        title: Text(cartItems[key].title),
                        subtitle: Text(
                          'x' +
                              cartItems[key].quantity.toString() +
                              'x' +
                              cartItems[key].price.toString() +
                              '=' +
                              (cartItems[key].quantity * cartItems[key].price)
                                  .toString(),
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: cartItems.length,
              ),
            ),
            OrderButton(total: total, cartItems: cartItems),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.total,
    @required this.cartItems,
  }) : super(key: key);

  final double total;
  final Map<String, CartItem> cartItems;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isload = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isload
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text('Order Now'),
      onPressed: widget.total <= 0 || isload
          ? null
          : () async {
              //Adding the items to orders
              setState(() {
                isload = true;
              });
              await Provider.of<Order>(context, listen: false).addToOrderItems(
                widget.cartItems.values.toList(),
                Provider.of<Cart>(context, listen: false).totalAmountForCarts,
              );

              setState(() {
                isload = false;
              });
              //clearing the cartTems after order placed
              Provider.of<Cart>(context, listen: false).clearCart();
            },
    );
  }
}
