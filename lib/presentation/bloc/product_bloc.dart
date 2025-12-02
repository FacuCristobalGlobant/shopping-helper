import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hive_ce_poc/core/bloc.dart';
import 'package:hive_ce_poc/core/bloc_state.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';
import 'package:hive_ce_poc/domain/repositories/database_repository.dart';

class ProductBloc extends Bloc {
  ProductBloc({required this.repository});

  final List<Product> _products = [];

  final List<Product> _filteredProducts = [];

  final Set<Filter<Product>> _filters = {};

  final StreamController<BlocState> _productsController =
      StreamController<BlocState>.broadcast();

  final StreamController<BlocState> _filteredResultsController =
      StreamController<BlocState>.broadcast();

  final DatabaseRepository<Product> repository;

  List<Product> get productsList => _products;

  List<Product> get filteredProductsList => _filteredProducts;

  bool isIncludedInFilters(Product product) {
    for (Filter filter in _filters) {
      if (filter.includes(product)) {
        return true;
      }
    }
    return false;
  }

  Stream<BlocState> get productsStream => _productsController.stream;

  Stream<BlocState> get filteredProductsStream =>
      _filteredResultsController.stream;

  @override
  void dispose() {
    _productsController.close();
  }

  @override
  void initialize() {
    _productsController.sink.add(LoadingBlocState());
    _filteredResultsController.sink.add(LoadingBlocState());
    try {
      _products.addAll(repository.get());
      _productsController.sink.add(SuccessBlocState(result: _products));
      _filteredProducts.addAll(_products);
      _filteredResultsController.sink.add(
        SuccessBlocState(result: _filteredProducts),
      );
    } catch (exception) {
      _productsController.sink.add(ErrorBlocState());
      _filteredResultsController.sink.add(ErrorBlocState());
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final int? id = await repository.insert(product);
      final Product insertedProduct = repository.getById(id!)!;
      _products.clear();
      _products.addAll(repository.get());
      _productsController.sink.add(
        SuccessBlocState(
          result: Action<Product>(action: 'create', item: insertedProduct),
        ),
      );
      _applyFilters();
    } catch (exception) {
      _productsController.sink.add(ErrorBlocState());
    }
  }

  Future<Product?> deleteProduct(int id) async {
    try {
      final Product? deletedProduct = await repository.delete(id);
      _products.clear();
      _products.addAll(repository.get());
      _productsController.sink.add(
        SuccessBlocState(
          result: Action<Product>(action: 'delete', item: deletedProduct!),
        ),
      );
      _applyFilters();
      return deletedProduct;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void _getAllProducts() async {
    try {
      _products.clear();
      _products.addAll(repository.get());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addNameFilter(String filterInput) {
    _filters.removeWhere((Filter filter) => filter is NameMatchFilter);
    _filters.add(NameMatchFilter(input: filterInput));
    _applyFilters();
  }

  void updateCategoriesFilter({required List<String> categories}) {
    _filters.removeWhere((Filter filter) => filter is CategoryFilter);
    if (categories.isEmpty) {
      _applyFilters();
      return;
    } else {
      _filters.add(CategoryFilter(categories: categories));
      _applyFilters();
    }
  }

  void _applyFilters() {
    _getAllProducts();
    if (_filters.isEmpty) {
      _filteredProducts.clear();
      _filteredProducts.addAll(_products);
      _filteredResultsController.sink.add(
        SuccessBlocState(result: _filteredProducts),
      );
      return;
    }
    List<Product> result = _products;
    for (var filter in _filters) {
      result = filter.apply(result);
    }
    _filteredProducts.clear();
    _filteredProducts.addAll(result);
    _filteredResultsController.sink.add(
      SuccessBlocState(result: _filteredProducts),
    );
  }
}

class Action<T> {
  Action({required this.action, required this.item});

  final String action;
  final T item;
}

abstract class Filter<T> {
  List<T> apply(List<T> list);

  bool includes(T item);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Filter && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class CategoryFilter extends Filter<Product> {
  CategoryFilter({required this.categories});

  final List<String> categories;

  @override
  List<Product> apply(List<Product> list) {
    final List<Product> result = [];

    for (var item in list) {
      if (categories.contains(item.category.name)) {
        result.add(item);
      }
    }

    return result;
  }

  @override
  bool includes(Product item) {
    return categories.contains(item.category.toString());
  }
}

class NameMatchFilter extends Filter<Product> {
  NameMatchFilter({required this.input});

  final String input;

  @override
  List<Product> apply(List<Product> list) {
    final List<Product> result = [];

    for (var item in list) {
      if (item.name.contains(input)) {
        result.add(item);
      }
    }

    return result;
  }

  @override
  bool includes(Product item) {
    return item.name.contains(input);
  }
}
