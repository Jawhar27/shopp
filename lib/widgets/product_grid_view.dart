import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import 'package:shopp/providers/product_details.dart';

class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductDetails>(context).listOfProduct;
    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider(
          create: (c) => product[index],
          child: ProductItem(),
        );
      },
      itemCount: product.length,
    );
  }
}
