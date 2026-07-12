import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/cart/domain/entities/cart_item.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_detail_viewmodel.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_detail_state.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/product_detail_shimmer.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/view/cart_screen.dart';
import '../../../cart/presentation/viewmodel/cart_state.dart';
import '../../../cart/presentation/viewmodel/cart_viewmodel.dart';
import '../../domain/entities/product.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productDetailViewModelProvider.notifier)
          .loadProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailViewModelProvider);
    final cartState = ref.watch(cartViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (cartState is CartLoaded && cartState.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartState.items.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: switch (state) {
        ProductDetailLoading() => const ProductDetailShimmer(),
        ProductDetailLoaded(product: final product) => _buildProductDetail(
          product,
        ),
        ProductDetailError(message: final message) => Center(
          child: Text('Error: $message'),
        ),
      },
    );
  }

  Widget _buildProductDetail(Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            width: double.infinity,
            height: 300,
            child: Image.network(product.image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            product.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            product.description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 24),

          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final cartItem = CartItem(
                  id: product.id,
                  title: product.title,
                  price: product.price,
                  imageUrl: product.image,
                  quantity: 1,
                );
                ref.read(cartViewModelProvider.notifier).addItem(cartItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to cart'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
