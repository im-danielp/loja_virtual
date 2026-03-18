import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModel = CartModel.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        splashColor: Colors.transparent,
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              initialValue: cartModel.cupomCode ?? '',
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance.collection('cupons').doc(text).get().then((docSnap) {
                  if (!context.mounted) return;
                  final doc = docSnap.data();

                  if (doc != null) {
                    cartModel.setCupom(text, doc['percent']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Desconto de ${doc['percent']}% aplicado'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  } else {
                    cartModel.setCupom(null, 0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cupom não encontrado'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hint: Text('Insira seu cupom'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
