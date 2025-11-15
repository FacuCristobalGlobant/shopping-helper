import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_poc/data/datasource/database.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';

import '../../core/string_constants.dart';
import '../models/product_model.dart';

class HiveDatabase extends Database<ProductModel> {
  final Box<ProductModel> box = Hive.box<ProductModel>(
    StringConstants.productBox,
  );

  @override
  Future<int?> delete(int id) async {
    try {
      await box.delete(id);
      return id;
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }

  @override
  Future<Map<dynamic, ProductModel>> get() async {
    try {
      return box.toMap();
    } catch (exception) {
      debugPrint('unable to retrieve values');
      return {};
    }
  }

  @override
  Future<ProductModel?> getById(int id) async {
    try {
      return box.getAt(id);
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
