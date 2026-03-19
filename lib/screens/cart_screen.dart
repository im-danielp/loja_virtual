import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:loja_virtual/widgets/user_not_logged_in.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu carrinho'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                final p = model.products.length;
                return Text('$p ${p == 1 ? 'Item' : 'Itens'}');
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          final user = UserModel.of(context);

          if (model.isLoading && user.isLoggedIn()) {
            return CircularProgressIndicator();
          } else if (!user.isLoggedIn()) {
            return UserNotLoggedIn(
              text: 'Faça login para adicionar produtos',
              icon: Icons.remove_shopping_cart,
            );
          } else if (model.products.isEmpty) {
            return Center(
              child: Text(
                'Nenhum produto no carrinho!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: [
                Column(
                  children: model.products
                      .map((product) => CartTile(cartProduct: product))
                      .toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(
                  buy: () async {
                    final orderId = await model.finishOrder();
                    if (orderId != null && context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(orderId: orderId),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
