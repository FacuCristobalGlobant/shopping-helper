import '../../domain/entities/product.dart';

class ProductModel{
  ProductModel({
    required this.name,
    required this.description,
    required this.category,
  });

  final String name;
  final String? description;
  final Category category;
}
