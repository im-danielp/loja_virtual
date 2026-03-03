import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  late String cid;
  late String catagory;
  late String pid;
  late int quantity;
  late String size;
  late ProductData productData;

  CartProduct.fromDocument(DocumentSnapshot document) {
    final doc = document.data() as Map<String, dynamic>;

    cid = document.id;
    catagory = doc['category'];
    pid = doc['pid'];
    quantity = doc['quantity'];
    size = doc['size'];
  }

  Map<String, dynamic> tomMap() {
    return {
      'cid': cid,
      'catagory': catagory,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      'productData': productData.toResumedMap(),
    };
  }
}
