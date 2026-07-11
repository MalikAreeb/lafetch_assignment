import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/cart/domain/entities/cart_item.dart';
import 'package:lafetch_assignment/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:lafetch_assignment/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:lafetch_assignment/features/cart/domain/usecases/remove_from_cart_usecase.dart';

import 'package:lafetch_assignment/features/cart/presentation/providers/cart_provider.dart';
import 'cart_state.dart';

class CartViewModel extends Notifier<CartState> {
  @override
  CartState build() {
    // Initial state - load cart
    return CartLoaded(
      items: ref.read(getCartUseCaseProvider).call(),
      totalPrice: _calculateTotal(),
    );
  }

  void addItem(CartItem item) {
    ref.read(addToCartUseCaseProvider).call(item);
    _refreshState();
  }

  void removeItem(int productId) {
    ref.read(removeFromCartUseCaseProvider).call(productId);
    _refreshState();
  }

  double _calculateTotal() {
    final items = ref.read(getCartUseCaseProvider).call();
    double total = 0.0;
    for (var item in items) {
      total += item.totalPrice;
    }
    return total;
  }

  void _refreshState() {
    final items = ref.read(getCartUseCaseProvider).call();
    state = CartLoaded(items: items, totalPrice: _calculateTotal());
  }
}

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(() {
  return CartViewModel();
});
