import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_viewmodel.dart';
import '../viewmodel/product_state.dart';

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productListViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('La-Fetch')),
      body: switch (state) {
        ProductListLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        ProductListLoaded(products: final products) => Text(
          'Loaded ${products.length} products',
        ), // placeholder for now
        ProductListError(message: final message) => Center(
          child: Text('Error: $message'),
        ),
      },
    );
  }
}
