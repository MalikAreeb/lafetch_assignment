import '../../domain/entities/product.dart';

sealed class ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  ProductDetailLoaded(this.product);
}

class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError(this.message);
}
