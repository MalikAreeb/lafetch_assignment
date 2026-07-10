import 'package:lafetch_assignment/features/cart/domain/repo/cart_repo.dart';

import '../../domain/entities/cart_item.dart';


class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _cartItems = [];

  @override
  List<CartItem> getCartItems() {
    return _cartItems;
  }

  @override
  void addItem(CartItem item) {
    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    
    if (existingIndex != -1) {
      // If exists, increment quantity
      _cartItems[existingIndex].quantity += item.quantity;
    } else {
      // If not exists, add new item
      _cartItems.add(item);
    }
  }

  @override
  void removeItem(int productId) {
    _cartItems.removeWhere((item) => item.id == productId);
  }

  @override
  void updateQuantity(int productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        // If quantity is 0 or less, remove item
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
    }
  }

  @override
  void clearCart() {
    _cartItems.clear();
  }

  @override
  int get totalItems {
    int total = 0;
    for (var item in _cartItems) {
      total += item.quantity;
    }
    return total;
  }

  @override
  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }
}