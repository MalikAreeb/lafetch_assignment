import 'package:lafetch_assignment/features/product/domain/repositories/product_repository.dart';
import '../entities/product.dart';
 // ← Interface, not implementation

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Product> call(int id) async {
    return await repository.getProductById(id);
  }
}