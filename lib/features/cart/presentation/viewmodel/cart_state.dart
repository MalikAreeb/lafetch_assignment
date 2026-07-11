import '../../domain/entities/cart_item.dart';

sealed class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartLoaded({required this.items, required this.totalPrice});
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
