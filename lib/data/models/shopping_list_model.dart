import 'package:hive_ce_poc/data/models/shopping_list_item_model.dart';

class ShoppingListModel {
  ShoppingListModel({
    required this.name,
    required this.description,
    required this.items,
  });

  final String name;
  final String? description;
  final List<ShoppingListItemModel> items;
}
