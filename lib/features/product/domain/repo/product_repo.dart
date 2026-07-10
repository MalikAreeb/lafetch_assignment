import 'package:lafetch_assignment/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<Product> getProductById(int id);
}
