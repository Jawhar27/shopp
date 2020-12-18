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
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imgUrl,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: 15),
            Container(
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 15),
            Text(
              '\$${product.price}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 1000,
            )
          ]))
        ],
      ),

      // Column(
      //   children: [
      //     Container(
      //       height: 300,
      //       width: double.infinity,
      //       child:
      //           Hero(tag: product.id, child: Image.network(product.imgUrl)),
      //     ),
      //     SizedBox(height: 15),
      //     Container(
      //       child: Text(
      //         product.description,
      //         textAlign: TextAlign.center,
      //         style: TextStyle(fontSize: 25),
      //       ),
      //     ),
      //     SizedBox(height: 15),
      //     Text(
      //       '\$${product.price}',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(fontSize: 25),
      //     )
      //   ],
      // )'
    );
  }
}
