import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  final String category;
  final String id;
  final String title;
  final String description;
  final double price;
  final List images;
  final List sizes;

  ProductData({
    required this.category,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.sizes,
  });

  factory ProductData.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductData(
      category: '',
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      images: data['images'] ?? [],
      sizes: data['sizes'] ?? [],
    );
  }
}
