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
            final double price = model.getProductPrice();
            final double discount = model.getDiscount();
            final double ship = model.getShipPrice();
            final double total = price + ship - discount;

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
                    Text('R\$ ${formater(price)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desconto '),
                    Visibility(
                      visible: discount > 0,
                      replacement: Text('R\$0,00'),
                      child: Text('-R\$ ${formater(discount)}'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Entrega '),
                    Text('R\$ ${formater(ship)}'),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total ', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                      'R\$ ${formater(total)}',
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

  String formater(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }
}
