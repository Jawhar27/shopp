import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/models/products.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            // onTap: () {
            //   // Navigator.of(context)
            //   //     .pushNamed('/product_detail_screen', arguments: {
            //   //   'title': title,
            //   //   'description': description,
            //   //   'price': price,
            //   //   'id': id,
            //   // });
            // },
            child: Image.network(
              product.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFav();
                },
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border)),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
