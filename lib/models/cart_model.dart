import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;

  String? cupomCode;
  int discountPercentage = 0;

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  CartModel(this.user) {
    if (user.isLoggedIn()) loadCartItems();
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .add(cartProduct.tomMapToFirebase())
        .then((doc) {
          cartProduct.cid = doc.id;
        });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    products.remove(cartProduct);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity = (cartProduct.quantity ?? 0) - 1;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.tomMapToFirebase());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity = (cartProduct.quantity ?? 0) + 1;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.tomMapToFirebase());
    notifyListeners();
  }

  void loadCartItems() async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void updatePrices() {
    notifyListeners();
  }

  void setCupom(String? cupomCode, int discountPercentage) {
    this.cupomCode = cupomCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductPrice() {
    double price = 0;
    for (final c in products) {
      if (c.productData != null) price += (c.quantity ?? 0) * (c.productData!.price ?? 0.0);
    }
    return price;
  }

  double getDiscount() {
    return getProductPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;
    isLoading = true;
    notifyListeners();

    double productPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    final refOrder = await FirebaseFirestore.instance.collection('orders').add({
      'clientId': user.firebaseUser!.uid,
      'products': products.map((cartProduct) => cartProduct.tomMap()).toList(),
      'shipPrice': shipPrice,
      'productsPrice': productPrice,
      'discount': discount,
      'totalPrice': productPrice - discount + shipPrice,
      'status': 1,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('orders')
        .doc(refOrder.id)
        .set({'orderId': refOrder.id});

    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();

    for (final doc in query.docs) {
      doc.reference.delete();
    }

    products.clear();
    discountPercentage = 0;
    cupomCode = null;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }
}
