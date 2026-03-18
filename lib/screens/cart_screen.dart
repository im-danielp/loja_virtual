import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
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
            return NoLoginCart();
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
                CartPrice(buy: () {}),
              ],
            );
          }
        },
      ),
    );
  }
}

class NoLoginCart extends StatelessWidget {
  const NoLoginCart({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Icon(
            Icons.remove_shopping_cart,
            size: 80,
            color: primaryColor,
          ),
          Text(
            'Faça login para adicionar produtos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: primaryColor),
            child: Text('Entrar', style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
