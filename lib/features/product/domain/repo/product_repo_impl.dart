import 'package:lafetch_assignment/core/error/exceptions.dart';
import 'package:lafetch_assignment/core/network/dio_client.dart';
import 'package:lafetch_assignment/features/product/domain/entities/product.dart';
import 'package:lafetch_assignment/features/product/domain/repo/product_repo.dart';
import '../../data/model/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient dioClient;

  ProductRepositoryImpl(this.dioClient);

  @override
  Future<List<Product>> getProducts() async {
    try {
      var response = await dioClient.dio.get('/products');
      List<Product> products = (response.data as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList();
      return products;
    } catch (e) {
      throw ServerException('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      var response = await dioClient.dio.get('/products/categories');
      List<String> categories = (response.data as List).cast<String>();
      return categories;
    } catch (e) {
      throw ServerException('Failed to fetch categories: $e');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      var response = await dioClient.dio.get('/products/$id');
      Product product = ProductModel.fromJson(response.data);
      return product;
    } catch (e) {
      throw ServerException('Failed to fetch product: $e');
    }
  }
}
