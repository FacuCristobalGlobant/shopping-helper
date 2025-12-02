import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_poc/data/datasource/database.dart';

import '../../core/string_constants.dart';
import '../models/product_model.dart';

class HiveDatabase extends Database<ProductModel> {
  final Box<ProductModel> box = Hive.box<ProductModel>(
    StringConstants.productBox,
  );

  @override
  Future<ProductModel?> delete(int id) async {
    try {
      final itemToRemove = box.get(id);
      await box.delete(id);
      return itemToRemove;
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }

  @override
  Map<dynamic, ProductModel> get() {
    try {
      return box.toMap();
    } catch (exception) {
      debugPrint('unable to retrieve values');
      return {};
    }
  }

  @override
  ProductModel? getById(int id) {
    try {
      return box.get(id);
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }

  @override
  Future<int?> insert(ProductModel element) async {
    try {
      return await box.add(element);
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }
}
