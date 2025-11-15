import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_poc/domain/entities/shopping_list_item.dart';

part 'shopping_list.freezed.dart';

@Freezed()
abstract class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required int id,
    required List<ShoppingListItem> productsId,
    required String name,
    String? description,
  }) = _ShoppingList;
}
