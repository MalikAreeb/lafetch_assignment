import 'package:lafetch_assignment/features/product/domain/repositories/product_repository.dart';
import '../entities/product.dart';
// ← Interface, not implementation

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}