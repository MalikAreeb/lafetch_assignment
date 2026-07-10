// Raw json

// {
//   "id": 1,
//   "title": "...",
//   "price": 109.95,
//   "description": "...",
//   "category": "...",
//   "image": "...",
//   "rating": {
//     "rate": 3.9,
//     "count": 120
//   }
// }

import 'package:lafetch_assignment/features/product/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
    required super.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: json['rating']['rate'].toDouble(),
      ratingCount: json['rating']['count'],
    );
  }
}
