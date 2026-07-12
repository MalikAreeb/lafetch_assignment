import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:lafetch_assignment/features/cart/presentation/viewmodel/cart_state.dart';
import '../../domain/entities/cart_item.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: switch (state) {
        CartLoading() => const Center(child: CircularProgressIndicator()),
        CartLoaded(items: final items, totalPrice: final totalPrice) =>
          items.isEmpty
              ? _buildEmptyCart(context)
              : Column(
                  children: [
                    // Cart items list
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _buildCartItem(item, ref);
                        },
                      ),
                    ),
                    // Bottom bar with total and checkout
                    _buildBottomBar(totalPrice, ref, context),
                  ],
                ),
        CartError(message: final message) => Center(
          child: Text('Error: $message'),
        ),
      },
    );
  }

  // Empty cart widget
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  // Single cart item widget
  Widget _buildCartItem(CartItem item, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported);
                },
              ),
            ),
            const SizedBox(width: 12),
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (item.quantity > 1) {
                    } else {
                      ref
                          .read(cartViewModelProvider.notifier)
                          .removeItem(item.id);
                    }
                  },
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref
                        .read(cartViewModelProvider.notifier)
                        .removeItem(item.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bottom bar with total and checkout button
  Widget _buildBottomBar(
    double totalPrice,
    WidgetRef ref,
    BuildContext context,
  ) {
    print(
      'Total Price: $totalPrice',
    ); // Debugging line to check the total price
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total', style: TextStyle(color: Colors.grey)),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _showCheckoutDialog(context, ref);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  // Checkout dialog
  void _showCheckoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: const Text('Your order has been placed successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
