import 'package:lafetch_assignment/features/cart/domain/repositories/cart_repository.dart';
// ← Interface, not implementation

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  void call(int productId) {
    repository.removeItem(productId);
  }
}
