import 'package:flutter/material.dart';
import 'package:shopp/widgets/product_grid_view.dart';

class ProductOverViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: new ProductGridView(),
    );
  }
}
