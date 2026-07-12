import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/cart/domain/entities/cart_item.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_detail_viewmodel.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_detail_state.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/product_detail_shimmer.dart';
import '../../../../core/theme/theme.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image block with its own background
          Container(
            width: double.infinity,
            height: 320,
            color: AppColors.surface,
            child: CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category tag
                Text(
                  product.category.toUpperCase(),
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 6),

                // Title
                Text(product.title, style: AppTextStyles.heading1),
                const SizedBox(height: 10),

                // Rating row
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.secondary, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rating}  (${product.ratingCount} reviews)',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.price.copyWith(fontSize: 22),
                ),

                const Divider(height: 32, color: AppColors.divider),

                // Description label
                Text('Description', style: AppTextStyles.heading2),
                const SizedBox(height: 8),
                Text(product.description, style: AppTextStyles.body),

                const SizedBox(height: 28),

                // Add to Cart button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final cartItem = CartItem(
                        id: product.id,
                        title: product.title,
                        price: product.price,
                        imageUrl: product.image,
                        quantity: 1,
                      );
                      ref
                          .read(cartViewModelProvider.notifier)
                          .addItem(cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
