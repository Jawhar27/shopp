import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/providers/product_details.dart';
import 'package:shopp/screens/product_detail_screen.dart';
import 'package:shopp/screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetails(),
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          routes: {
            '/product_detail_screen': (ctx) => ProductDetailScreen(),
          },
          home: ProductOverViewScreen()),
    );
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Text('welcome'),
    );
  }
}
