import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/product/presentation/providers/product_provider.dart';
import 'package:lafetch_assignment/features/product/presentation/view/product_detail.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/category_shimmer.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/product_card.dart';
import 'package:lafetch_assignment/features/product/presentation/widgets/product_grid_shimmer.dart';
import '../viewmodel/product_state.dart';

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productListViewModelProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('La-Fetch'),
        actions: [
          // Cart icon with badge
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart screen later
            },
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
              ProductListLoaded(products: final products) => GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.77,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(
                            productId: products[index].id,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              ProductListError(message: final message) => Center(
                child: Text('Error: $message'),
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
