import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/cart/presentation/view/cart_screen.dart';
import 'package:lafetch_assignment/features/product/presentation/providers/product_provider.dart';
import 'package:lafetch_assignment/features/product/presentation/view/product_detail.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/category_shimmer.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/product_card.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/product_grid_shimmer.dart';
import '../../../cart/presentation/viewmodel/cart_state.dart';
import '../../../cart/presentation/viewmodel/cart_viewmodel.dart';
import '../viewmodel/product_state.dart';

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productListViewModelProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final cartState = ref.watch(cartViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('La-Fetch'),
        actions: [
          // Cart icon with badge
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
      body: Column(
        children: [
          // Category chips
          categoriesAsync.when(
            data: (categories) => _buildCategoryChips(ref, categories),
            loading: () => const CategoryShimmer(), // ← Shimmer for categories
            error: (err, stack) => const SizedBox.shrink(),
          ),
          // Product grid
          Expanded(
            child: switch (state) {
              ProductListLoading() => const ProductGridShimmer(),
              ProductListLoaded(products: final products) => Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 2,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = (constraints.maxWidth / 240)
                          .floor()
                          .clamp(2, 5);

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: products[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productId: products[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              ProductListError(message: final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $message',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(productListViewModelProvider.notifier)
                              .loadProducts();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(WidgetRef ref, List<String> categories) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildChip(
              label: 'All',
              isSelected: selectedCategory == null,
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = null;
              },
            );
          }
          final category = categories[index - 1];
          return _buildChip(
            label: category,
            isSelected: selectedCategory == category,
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
          );
        },
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }
}
