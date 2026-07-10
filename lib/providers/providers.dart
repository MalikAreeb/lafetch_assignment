// ============ DIO CLIENT ============
import 'package:lafetch_assignment/core/network/dio_client.dart';
import 'package:lafetch_assignment/features/cart/domain/repo/cart_repo.dart';
import 'package:lafetch_assignment/features/cart/domain/repo/cart_repo_impl.dart';
import 'package:lafetch_assignment/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:lafetch_assignment/features/product/domain/repo/product_repo.dart';
import 'package:lafetch_assignment/features/product/domain/repo/product_repo_impl.dart';
import 'package:lafetch_assignment/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:lafetch_assignment/features/product/domain/usecases/get_product_usecase.dart';
import '../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProductRepositoryImpl(dioClient);
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl();
});

// Product Use Cases
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repo);
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return GetProductByIdUseCase(repo);
});

// Cart use Case
final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return AddToCartUseCase(repo);
});

final getCartUseCaseProvider = Provider<GetCartUseCase>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return GetCartUseCase(repo);
});

final removeFromCartUseCaseProvider = Provider<RemoveFromCartUseCase>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return RemoveFromCartUseCase(repo);
});
