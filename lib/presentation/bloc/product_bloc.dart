import 'dart:async';
import 'dart:ui';

import 'package:hive_ce_poc/core/bloc.dart';
import 'package:hive_ce_poc/core/bloc_state.dart';
import 'package:hive_ce_poc/data/datasource/database.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';

class ProductBloc extends Bloc {
  ProductBloc({required this.database});

  final List<Product> _products = [];
  final List<Product> _searchResults = [];

  final StreamController<BlocState> _controller =
      StreamController<BlocState>.broadcast();

  final Database<Product> database;

  Stream<BlocState> get stream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }

  @override
  void initialize() async {
    _controller.sink.add(LoadingBlocState());
    try {
      _searchResults.addAll(await database.get());
      _controller.sink.add(SuccessBlocState(result: await database.get()));
    } catch (exception) {
      _controller.sink.add(ErrorBlocState());
    }
  }

  void addProduct(Product product) async {
    try {
      database.insert(product);
      _products.clear();
      _products.addAll(await database.get());
      _products.clear();
      _products.addAll(await database.get());
      refreshResults();
    } catch (exception) {
      _controller.sink.add(ErrorBlocState());
    }
  }

  void refreshResults() {
    _controller.sink.add(LoadingBlocState());
    _controller.sink.add(SuccessBlocState(result: _products));
  }
}
