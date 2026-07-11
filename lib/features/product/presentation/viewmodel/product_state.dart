import 'package:lafetch_assignment/features/product/domain/entities/product.dart';

sealed class ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  ProductListLoaded(this.products);
}

class ProductListError extends ProductListState {
  final String message;
  ProductListError(this.message);
}
