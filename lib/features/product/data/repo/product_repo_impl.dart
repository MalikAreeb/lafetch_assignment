import 'package:dio/dio.dart';
import 'package:lafetch_assignment/core/error/exceptions.dart';
import 'package:lafetch_assignment/core/network/dio_client.dart';
import 'package:lafetch_assignment/features/product/domain/entities/product.dart';
import 'package:lafetch_assignment/features/product/domain/repositories/product_repository.dart';
import '../model/product_model.dart';

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
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException(
          'No internet connection. Please check your network and try again.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Request timed out. Please try again.');
      } else if (e.response != null) {
        throw ServerException(
          'Server error (${e.response?.statusCode}). Please try again later.',
        );
      } else {
        throw ServerException('Something went wrong. Please try again.');
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      var response = await dioClient.dio.get('/products/categories');
      List<String> categories = (response.data as List).cast<String>();
      return categories;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException(
          'No internet connection. Please check your network and try again.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Request timed out. Please try again.');
      } else if (e.response != null) {
        throw ServerException(
          'Server error (${e.response?.statusCode}). Please try again later.',
        );
      } else {
        throw ServerException('Something went wrong. Please try again.');
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      var response = await dioClient.dio.get('/products/$id');
      Product product = ProductModel.fromJson(response.data);
      return product;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException(
          'No internet connection. Please check your network and try again.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException('Request timed out. Please try again.');
      } else if (e.response != null) {
        throw ServerException(
          'Server error (${e.response?.statusCode}). Please try again later.',
        );
      } else {
        throw ServerException('Something went wrong. Please try again.');
      }
    } catch (e) {
      throw ServerException('Unexpected error occurred. Please try again.');
    }
  }
}
