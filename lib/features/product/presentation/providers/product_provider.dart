import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/core/providers/core_provider.dart';
import 'package:lafetch_assignment/features/product/data/repo/product_repo.dart';
import 'package:lafetch_assignment/features/product/data/repo/product_repo_impl.dart';
import 'package:lafetch_assignment/features/product/domain/usecases/get_categories_usecase.dart';
import 'package:lafetch_assignment/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:lafetch_assignment/features/product/domain/usecases/get_product_usecase.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProductRepositoryImpl(dioClient);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repo);
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return GetProductByIdUseCase(repo);
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return GetCategoriesUseCase(repo);
});
