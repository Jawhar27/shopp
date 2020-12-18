import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopp/providers/product_details.dart';
import 'package:shopp/widgets/drawer.dart';
import 'package:shopp/widgets/user_product_item.dart';
import '../screens/edit_userProduct_screen.dart';

class ManageProductScreen extends StatelessWidget {
  static const routeName = '/manage_user_product';

  Future<void> _waitingForGettingData(BuildContext context) async {
    await Provider.of<ProductDetails>(context, listen: false)
        .fetchsetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductDetails>(context);
    //commented because it will create infinite loop
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Products'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditUserProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _waitingForGettingData(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _waitingForGettingData(context),
                      child: Consumer<ProductDetails>(
                        builder: (context, products, _) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: products.listOfProduct.length,
                              itemBuilder: (context, index) {
                                return UserProductItem(
                                  title: products.listOfProduct[index].title,
                                  imgUrl: products.listOfProduct[index].imgUrl,
                                  id: products.listOfProduct[index].id,
                                );
                              },
                            ),
                          );
                        },
                      )),
        ));
  }
}
