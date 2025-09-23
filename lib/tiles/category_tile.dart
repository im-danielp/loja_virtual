import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/products_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const CategoryTile({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(data['icon']),
      ),
      title: Text(data['title']),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsScreen(snapshot: snapshot),
        ),
      ),
    );
  }
}
