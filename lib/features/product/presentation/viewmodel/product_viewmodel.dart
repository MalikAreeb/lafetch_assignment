import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/core/error/exceptions.dart';
import 'package:lafetch_assignment/features/product/presentation/providers/product_provider.dart';
import 'package:lafetch_assignment/features/product/presentation/viewmodel/product_state.dart';

class ProductListViewModel extends Notifier<ProductListState> {
  @override
  ProductListState build() {
    loadProducts();
    return ProductListLoading();
  }

  Future<void> loadProducts() async {
    try {
      state = ProductListLoading();
      final getProductsUseCase = ref.read(getProductsUseCaseProvider);
      final products = await getProductsUseCase();
      state = ProductListLoaded(products);
    } catch (e) {
      state = ProductListError(e is ServerException ? e.message : e.toString());
    }
  }
}

final productListViewModelProvider =
    NotifierProvider<ProductListViewModel, ProductListState>(() {
      return ProductListViewModel();
    });
