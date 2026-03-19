import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/tiles/order_tile.dart';
import 'package:loja_virtual/widgets/user_not_logged_in.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.of(context);

    if (user.isLoggedIn()) {
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.firebaseUser!.uid)
            .collection('orders')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            final docs = snapshot.data!.docs.reversed.toList();
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return OrderTile(orderId: docs[index].id);
              },
            );
          }
        },
      );
    } else {
      return UserNotLoggedIn(
        text: 'Faça o login para acompanhar',
        icon: Icons.view_list_rounded,
      );
    }
  }
}
