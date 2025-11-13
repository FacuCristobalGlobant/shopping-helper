import 'dart:async';

import 'package:hive_ce_poc/core/bloc.dart';
import 'package:hive_ce_poc/domain/entities/shopping_list.dart';

import '../../core/bloc_state.dart';

class ShoppingListBloc implements Bloc {
  final List<ShoppingList> _shoppingLists = [];

  final _controller = StreamController<BlocState>.broadcast();

  Stream<BlocState> get stream => _controller.stream;

  List<ShoppingList> get shoppingLists => _shoppingLists;

  void addShoppingList(ShoppingList newShoppingList) {
    _shoppingLists.add(newShoppingList);
    _controller.sink.add(
      SuccessBlocState<List<ShoppingList>>(result: _shoppingLists),
    );
  }

  void deleteShoppingList(ShoppingList shoppingList) {
    _shoppingLists.remove(shoppingList);
    _updateStream();
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  void initialize() {
    _updateStream();
  }

  void _updateStream() {
    _shoppingLists.isNotEmpty
        ? {
            _controller.sink.add(
              SuccessBlocState<List<ShoppingList>>(result: _shoppingLists),
            ),
          }
        : _controller.sink.add(EmptyBlocState());
  }
}
