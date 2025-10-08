import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
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
                      'Adicionar ao carrinho',
                      style: TextStyle(
                        fontSize: 18,
                        color: selectedSize.isNotEmpty ? Colors.white : null,
                      ),
                    ),
                    onPressed: selectedSize.isNotEmpty ? () {} : null,
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
