import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import 'package:shopp/providers/product_details.dart';

class ProductGridView extends StatelessWidget {
  final bool isFav;
  ProductGridView(this.isFav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductDetails>(context, listen: false);

    final product =
        isFav ? productData.favOfproduct : productData.listOfProduct;

    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: product[index], //single product passing to product item
          child: ProductItem(),
        );
      },
      itemCount: product.length,
    );
  }
}
