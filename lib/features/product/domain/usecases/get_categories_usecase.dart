import 'package:lafetch_assignment/features/product/domain/repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getCategories();
  }
}
