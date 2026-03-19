import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  final String? id;
  String? category;
  final String? title;
  final String? description;
  final double? price;
  final List? images;
  final List? sizes;

  ProductData({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.sizes,
  });

  factory ProductData.fromDocument(DocumentSnapshot? snapshot) {
    final data = snapshot?.data() as Map<String, dynamic>;
    return ProductData(
      id: snapshot?.id,
      category: '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      images: data['images'] ?? [],
      sizes: data['sizes'] ?? [],
    );
  }

  @override
  String toString() {
    return 'ProductData{id: $id, category: $category, title: $title, description: $description, price: $price, images: $images, sizes: $sizes}';
  }

  Map<String, dynamic>? toResumedMap() {
    return {
      'title': title,
      'price': price,
    };
  }
}
