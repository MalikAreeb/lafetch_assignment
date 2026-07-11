import 'package:lafetch_assignment/features/cart/domain/repositories/cart_repository.dart';

import '../entities/cart_item.dart';
 // ← Interface, not implementation

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  void call(CartItem item) {
    repository.addItem(item);
  }
}