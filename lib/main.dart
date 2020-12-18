import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp/providers/auth.dart';
import 'package:shopp/providers/cart.dart';
import 'package:shopp/providers/order.dart';
import 'package:shopp/providers/product_details.dart';
import 'package:shopp/screens/auth_screen.dart';
import 'package:shopp/screens/cart_screen.dart';
import 'package:shopp/screens/edit_userProduct_screen.dart';
import 'package:shopp/screens/manage_product_screen.dart';
import 'package:shopp/screens/order_screen.dart';
import 'package:shopp/screens/product_detail_screen.dart';
import 'package:shopp/screens/product_overview_screen.dart';
import './providers/cart.dart';
import './screens/splashScreen.dart';
import './helpers/customRoute.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProductDetails>(
            create: null,
            update: (context, auth, previous) {
              return ProductDetails(auth.token, auth.getUserId,
                  previous == null ? [] : previous.listOfProduct);
            },
          ),

          // ChangeNotifierProvider(
          //   create: (context) => ProductDetails(),
          // ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: null,
            update: (context, auth, previousOrders) {
              return Order(
                  previousOrders == null ? [] : previousOrders.orderItems,
                  auth.token,
                  auth.getUserId);
            },
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          // ChangeNotifierProvider(create: (ctx) => Order()),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  pageTransitionsTheme: PageTransitionsTheme(
                      builders: ({
                    TargetPlatform.android: CustomTransitionBuilder(),
                    TargetPlatform.iOS: CustomTransitionBuilder(),
                  }))),
              routes: {
                '/product_detail_screen': (ctx) => ProductDetailScreen(),
                '/cart': (ctx) => CartScreen(),
                '/orderScreen': (ctx) => OrderScreen(),
                ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
                EditUserProductScreen.routeName: (ctx) =>
                    EditUserProductScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
              },
              home: //authenticated correctly
                  auth.isAuth
                      ? ProductOverViewScreen()
                      :
                      //if unauthenticated there is a possible chance for auto login.
                      FutureBuilder(
                          future: auth.autoLogin(),
                          builder: (ctx, snapshot) =>
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : AuthScreen(),
                        )),
        ));
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
