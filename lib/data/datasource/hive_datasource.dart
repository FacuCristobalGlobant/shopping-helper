import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_poc/data/datasource/database.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';

import '../../core/string_constants.dart';

class HiveDatabase extends Database<Product> {

  final Box<Product> box = Hive.box<Product>(StringConstants.productBox);

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
  Future<List<Product>> get() async {
    try {
      return box.values.toList();
    } catch (exception) {
      debugPrint('unable to retrieve values');
      return [];
    }
  }

  @override
  Future<Product?> getById(int id) async {
    try {
      return box.getAt(id);
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }

  @override
  Future<int?> insert(Product element) async {
    try {
      await box.add(element);
      return element.id;
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }

}