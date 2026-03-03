import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];

  CartModel(this.user);

  void addCartIteme(CartProduct cartProduct) {
    products.add(cartProduct);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.user!.uid)
        .collection('cart')
        .add(cartProduct.tomMap())
        .then((doc) {
          cartProduct.cid = doc.id;
        });
    notifyListeners();
  }

  void removeCartIteme(CartProduct cartProduct) {
    products.remove(cartProduct);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.user!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();
    notifyListeners();
  }
}
