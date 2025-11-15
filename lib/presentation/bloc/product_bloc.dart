import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hive_ce_poc/core/bloc.dart';
import 'package:hive_ce_poc/core/bloc_state.dart';
import 'package:hive_ce_poc/data/datasource/database.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';
import 'package:hive_ce_poc/domain/repositories/database_repository.dart';

class ProductBloc extends Bloc {
  ProductBloc({required this.repository});

  final List<Product> _products = [];
  final List<Product> _searchResults = [];

  final StreamController<BlocState> _controller =
      StreamController<BlocState>.broadcast();

  final DatabaseRepository<Product> repository;

  Stream<BlocState> get stream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }

  @override
  void initialize() async {
    _controller.sink.add(LoadingBlocState());
    try {
      _searchResults.addAll(await repository.get());
      _controller.sink.add(SuccessBlocState(result: await repository.get()));
    } catch (exception) {
      _controller.sink.add(ErrorBlocState());
    }
  }

  void addProduct(Product product) async {
    try {
      repository.insert(product);
      _products.clear();
      _products.addAll(await repository.get());
      refreshResults();
    } catch (exception) {
      _controller.sink.add(ErrorBlocState());
    }
  }

  Future<int?> deleteProduct(int id) async {
    try {
      final int? deletedItemId = await repository.delete(id);
      refreshResults();
      return deletedItemId;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<Product>> getAllProducts() async {
    final List<Product> result = [];

    try {
      result.addAll(await repository.get());
    } catch (e) {
      debugPrint(e.toString());
    }

    return result;
  }

  void refreshResults() async {
    _controller.sink.add(LoadingBlocState());
    _products.clear();
    _products.addAll(await getAllProducts());
    _controller.sink.add(SuccessBlocState(result: _products));
  }
}
