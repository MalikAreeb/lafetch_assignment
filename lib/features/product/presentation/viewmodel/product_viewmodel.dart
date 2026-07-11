import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/core/error/exceptions.dart';
import 'package:lafetch_assignment/features/product/domain/entities/product.dart';
import 'package:lafetch_assignment/features/product/presentation/providers/product_provider.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_state.dart';

class ProductListViewModel extends Notifier<ProductListState> {
  List<Product> _allProducts = [];

  @override
  ProductListState build() {
    loadProducts();
    // Listen to category changes
    ref.listen<String?>(selectedCategoryProvider, (previous, next) {
      _filterByCategory(next);
    });
    return ProductListLoading();
  }

  Future<void> loadProducts() async {
    try {
      state = ProductListLoading();
      final getProductsUseCase = ref.read(getProductsUseCaseProvider);
      _allProducts = await getProductsUseCase();
      _filterByCategory(ref.read(selectedCategoryProvider));
      state = ProductListLoaded(_allProducts);
    } catch (e) {
      state = ProductListError(e is ServerException ? e.message : e.toString());
    }
  }

  void _filterByCategory(String? category) {
    if (category == null || category.isEmpty) {
      state = ProductListLoaded(_allProducts);
    } else {
      final filtered = _allProducts
          .where((product) => product.category == category)
          .toList();
      state = ProductListLoaded(filtered);
    }
  }
}

final productListViewModelProvider =
    NotifierProvider<ProductListViewModel, ProductListState>(() {
      return ProductListViewModel();
    });
