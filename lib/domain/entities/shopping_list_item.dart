import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list_item.freezed.dart';

@Freezed()
abstract class ShoppingListItem with _$ShoppingListItem{
  const factory ShoppingListItem({
    required int id,
    required bool done,
    @Default(1)
    int quantity,
    required int itemId,
  }) = _ShoppingListItem;
}