import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/cart/data/repo/cart_repo.dart';
import 'package:lafetch_assignment/features/cart/data/repo/cart_repo_impl.dart';
import 'package:lafetch_assignment/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:lafetch_assignment/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:lafetch_assignment/features/cart/domain/usecases/remove_from_cart_usecase.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl();
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
