import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';

class ProductsScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const ProductsScreen({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final product = ProductData.fromDocument(snapshot);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title ?? ''),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('products')
              .doc(product.id)
              .collection('itens')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final data = ProductData.fromDocument(snapshot.data?.docs[index]);
                      return ProductTile(type: 'grid', product: data);
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(4),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final data = ProductData.fromDocument(snapshot.data?.docs[index]);
                      return ProductTile(type: 'list', product: data);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
