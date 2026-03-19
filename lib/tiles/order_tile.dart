import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  const OrderTile({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final int status = snapshot.data!['status'];
              return Column(
                spacing: 7,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código do pedido: ${snapshot.data!.id}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(buildProductsText(snapshot.data)),
                  Text(
                    'Status do pedido',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCircle('1', 'Preparação', status, 1),
                      Container(height: 1, width: 40, color: Colors.grey[500]),
                      buildCircle('2', 'Transporte', status, 2),
                      Container(height: 1, width: 40, color: Colors.grey[500]),
                      buildCircle('3', 'Entrega', status, 3),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String buildProductsText(DocumentSnapshot? data) {
    String text = 'Descição\n';

    for (final LinkedHashMap p in data!['products']) {
      final quantity = p['quantity'];
      final title = p['product']['title'];
      final price = p['product']['price'].toStringAsFixed(2);
      text += '$quantity x $title ($price)\n';
    }
    text += 'Total: R\$ ${data['totalPrice'].toStringAsFixed(2)}';
    return text;
  }

  Widget buildCircle(String title, String subtitle, int status, int thisStatus) {
    Color? backColor;
    Widget? child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: [
        CircleAvatar(radius: 20, backgroundColor: backColor, child: child),
        Text(subtitle),
      ],
    );
  }
}
