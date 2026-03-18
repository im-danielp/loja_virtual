import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/widgets/product_carousel.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final product = widget.product;
  String selectedSize = '';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final user = UserModel.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Produto'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ProductCarousel(imageUrls: product.images ?? []),
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.title ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  'R\$ ${product.price?.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tamanho',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children:
                        product.sizes
                            ?.map(
                              (size) => GestureDetector(
                                onTap: () {
                                  setState(() => selectedSize = size);
                                },
                                child: Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selectedSize == size
                                        ? primaryColor.withValues(alpha: 0.12)
                                        : null,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: selectedSize == size ? primaryColor : Colors.grey,
                                    ),
                                  ),
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      color: selectedSize == size ? primaryColor : null,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    icon: Icon(Icons.shopping_cart_outlined),
                    label: Text(
                      user.isLoggedIn() ? 'Adicionar ao carrinho' : 'Entre para comprar',
                      style: TextStyle(
                        fontSize: 18,
                        color: selectedSize.isNotEmpty ? Colors.white : null,
                      ),
                    ),
                    onPressed: selectedSize.isNotEmpty
                        ? () {
                            if (user.isLoggedIn()) {
                              final cartProduct = CartProduct();
                              cartProduct.size = selectedSize;
                              cartProduct.quantity = 1;
                              cartProduct.pid = product.id;
                              cartProduct.category = product.category;
                              cartProduct.productData = product;

                              CartModel.of(context).addCartItem(cartProduct);

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CartScreen()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            }
                          }
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Descrição',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(product.description ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
