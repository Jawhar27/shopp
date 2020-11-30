import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/providers/product_details.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var arguements =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;

    final product =
        Provider.of<ProductDetails>(context).findById(arguements['id']);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Text(product.description),
    );
  }
}
