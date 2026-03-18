import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  String? cid;
  String? category;
  String? pid;
  int? quantity;
  String? size;
  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    final doc = document.data() as Map<String, dynamic>;

    cid = document.id;
    category = doc['category'];
    pid = doc['pid'];
    quantity = doc['quantity'];
    size = doc['size'];
  }

  Map<String, dynamic> tomMapToFirebase() {
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> tomMap() {
    return {
      'cid': cid,
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      'productData': productData?.toResumedMap(),
    };
  }
}
