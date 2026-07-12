import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lafetch_assignment/core/error/exceptions.dart';
import 'package:lafetch_assignment/features/product/presentation/providers/product_provider.dart';

import 'product_detail_state.dart';

class ProductDetailViewModel extends Notifier<ProductDetailState> {
  @override
  ProductDetailState build() {
    return ProductDetailLoading(); // Initial state
  }

  Future<void> loadProduct(int productId) async {
    try {
      state = ProductDetailLoading();
      final getProductByIdUseCase = ref.read(getProductByIdUseCaseProvider);
      final product = await getProductByIdUseCase(productId);
      state = ProductDetailLoaded(product);
    } catch (e) {
      String message;
      if (e is ServerException) {
        message = e.message;
      } else if (e is NetworkException) {
        message = e.message;
      } else {
        message = 'Something went wrong. Please try again.';
      }
      state = ProductDetailError(message);
    }
  }
}

final productDetailViewModelProvider =
    NotifierProvider<ProductDetailViewModel, ProductDetailState>(() {
      return ProductDetailViewModel();
    });
