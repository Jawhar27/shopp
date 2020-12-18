import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/providers/products.dart';
import 'package:shopp/providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);
    final authData = Provider.of<Auth>(context);

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/product_detail_screen', arguments: {
                  'title': product.title,
                  'description': product.description,
                  'price': product.price,
                  'id': product.id,
                });
              },
              child:
                  // showing product items
                  // Image.network(
                  //   product.imgUrl,
                  //   fit: BoxFit.cover,
                  // ),
                  //animated using placeholder images
                  Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imgUrl),
                  fit: BoxFit.cover,
                ),
              )),
          footer: GridTileBar(
            leading: Consumer<Products>(
              builder: (ctx, product, child) => IconButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    product.toggleFav(authData.token, authData.getUserId);
                  },
                  icon: Icon(product.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border)),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            trailing: Consumer<Cart>(
              builder: (context, value, child) {
                return IconButton(
                  color: Theme.of(context).accentColor,
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    value.addCartItems(
                        product.id, product.title, product.price);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('added to cart!'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          value.removeSingleItem(product.id);
                        },
                      ),
                    ));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
