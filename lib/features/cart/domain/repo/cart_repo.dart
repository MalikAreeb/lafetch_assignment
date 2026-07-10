import '../entities/cart_item.dart';

abstract class CartRepository {
  List<CartItem> getCartItems();
  void addItem(CartItem item);
  void removeItem(int productId);
  void updateQuantity(int productId, int quantity);
  void clearCart();
  int get totalItems;
  double get totalPrice;
}
