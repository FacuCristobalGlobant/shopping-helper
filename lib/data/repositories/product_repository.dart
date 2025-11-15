import 'package:hive_ce_poc/data/datasource/database.dart';
import 'package:hive_ce_poc/data/models/product_model.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';
import 'package:hive_ce_poc/domain/repositories/database_repository.dart';

class ProductRepository extends DatabaseRepository<Product> {
  ProductRepository({required this.database});

  final Database<ProductModel> database;

  @override
  Future<int?> delete(int id) {
    return database.delete(id);
  }

  @override
  Future<List<Product>> get() async {
    final Map<dynamic, ProductModel> productModels = await database.get();

    final List<Product> result = [];

    productModels.forEach((dynamic key, ProductModel value) {
      final int id = key as int;
      result.add(
        Product(
          id: id,
          name: value.name,
          category: value.category,
          description: value.description,
        ),
      );
    });

    return result;
  }

  @override
  Future<Product?> getById(int id) async {
    final result = await database.getById(id);

    if (result == null) return null;

    return Product(
      id: id,
      name: result.name,
      category: result.category,
      description: result.description,
    );
  }

  @override
  Future<int?> insert(element) {
    return database.insert(
      ProductModel(
        name: element.name,
        description: element.description,
        category: element.category,
      ),
    );
  }
}
