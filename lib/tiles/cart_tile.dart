import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  const CartTile({
    super.key,
    required this.cartProduct,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildContent(BuildContext context) {
      CartModel.of(context).updatePrices();
      final primaryColor = Theme.of(context).primaryColor;

      return Row(
        children: [
          SizedBox(
            width: 120,
            child: cartProduct.productData?.images?.isNotEmpty ?? false
                ? Image.network(cartProduct.productData?.images?[0], fit: BoxFit.cover)
                : Icon(Icons.wifi_tethering_error_rounded_rounded),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProduct.productData?.title ?? 'Produto sem título',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tamanho: ${cartProduct.size}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R\$ ${cartProduct.productData?.price?.toStringAsFixed(2) ?? '--,-'}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        color: primaryColor,
                        onPressed: cartProduct.quantity == 1
                            ? null
                            : () => CartModel.of(context).decProduct(cartProduct),
                        icon: Icon(Icons.remove),
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        color: primaryColor,
                        onPressed: () => CartModel.of(context).incProduct(cartProduct),
                        icon: Icon(Icons.add),
                      ),
                      TextButton(
                        onPressed: () => CartModel.of(context).removeCartItem(cartProduct),
                        child: Text('Remover', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .doc(cartProduct.category)
                  .collection('itens')
                  .doc(cartProduct.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cartProduct.productData = ProductData.fromDocument(snapshot.data);
                  return buildContent(context);
                } else {
                  return Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : buildContent(context),
    );
  }
}
