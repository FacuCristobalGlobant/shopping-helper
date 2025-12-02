class ShoppingListItemModel {
  ShoppingListItemModel({
    required this.done,
    required this.quantity,
    required this.productId,
  });

  final bool done;
  final int quantity;
  final int productId;
}
