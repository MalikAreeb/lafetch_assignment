import 'package:lafetch_assignment/features/cart/domain/repositories/cart_repository.dart';

import '../entities/cart_item.dart';
// ← Interface, not implementation

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  List<CartItem> call() {
    return repository.getCartItems();
  }
}
