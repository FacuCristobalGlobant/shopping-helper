import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';

@Freezed()
abstract class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required int id,
    required List<int> productsId,
    required String name,
    String? description,
  }) = _ShoppingList;
}
