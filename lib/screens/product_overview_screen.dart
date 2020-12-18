import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/providers/cart.dart';
import 'package:shopp/providers/product_details.dart';
import 'package:shopp/widgets/badge.dart';
import 'package:shopp/widgets/drawer.dart';
import 'package:shopp/widgets/product_grid_view.dart';
// import 'package:provider/provider.dart';
// import '../providers/product_details.dart';
import '../widgets/badge.dart';

enum Category {
  Favourites,
  AllCategories,
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _isFavourite = false;
  var isInit = true;
  var isLoad = true;
  // @override
  // void initState() {
  //   Provider.of<ProductDetails>(context, listen: false).fetchsetProducts();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() async {
    if (isInit) {
      await Provider.of<ProductDetails>(context).fetchsetProducts().then((_) {
        setState(() {
          isLoad = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == Category.Favourites) {
                  _isFavourite = true;
                } else {
                  _isFavourite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favourites'),
                value: Category.Favourites,
              ),
              PopupMenuItem(
                child: Text('All Categories'),
                value: Category.AllCategories,
              ),
            ],
          ),
          Consumer<Cart>(builder: (context, cartData, _) {
            return Badge(
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                },
              ),
              value: cartData.cartMapLength.toString(),
              color: Colors.blue,
            );
          }),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGridView(_isFavourite),
    );
  }
}
