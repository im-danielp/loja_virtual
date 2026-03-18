import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;

  const CartPrice({
    super.key,
    required this.buy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            final String price = model.getProductPrice().toStringAsFixed(2).replaceAll('.', ',');
            final String discount = model.getDiscount().toStringAsFixed(2).replaceAll('.', ',');
            final String ship = model.getShipPrice().toStringAsFixed(2).replaceAll('.', ',');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Text(
                  'Resumo do pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal '),
                    Text('R\$ $price'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desconto '),
                    Text('R\$ $discount'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Entrega '),
                    Text('R\$ $ship'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total ', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                      'R\$ 0,00',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: buy,
                  child: Text('Finalizar pedido'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
