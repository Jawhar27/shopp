import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopp/providers/product_details.dart';
import 'package:shopp/screens/edit_userProduct_screen.dart';

class UserProductItem extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String id;
  UserProductItem(
      {@required this.id, @required this.title, @required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditUserProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                try {
                  await Provider.of<ProductDetails>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // if we use directly error will occur. "Loooing up a deactivated widget's ancestor(parent --moodhadhaiyar) is unsafe"
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'cannot delete the product',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
