import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartScreen(),
          ),
        );
      },
      shape: CircleBorder(),
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }
}
