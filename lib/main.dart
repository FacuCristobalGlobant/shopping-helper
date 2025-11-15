import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hive_ce_poc/data/datasource/hive_datasource.dart';
import 'package:hive_ce_poc/data/models/product_model.dart';
import 'package:hive_ce_poc/data/models/shopping_list_model.dart';
import 'package:hive_ce_poc/data/repositories/product_repository.dart';
import 'package:hive_ce_poc/domain/entities/shopping_list.dart';
import 'package:hive_ce_poc/domain/repositories/database_repository.dart';
import 'package:hive_ce_poc/presentation/base_scaffold.dart';
import 'package:hive_ce_poc/presentation/bloc/product_bloc.dart';
import 'package:hive_ce_poc/presentation/bloc/shopping_list_bloc.dart';
import 'package:hive_ce_poc/presentation/pages/home_page.dart';
import 'package:hive_ce_poc/presentation/pages/products_page.dart';
import 'package:provider/provider.dart';

import 'core/string_constants.dart';
import 'data/datasource/database.dart';
import 'domain/entities/product.dart';
import '/hive/hive_registrar.g.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            return BaseScaffold(navigationShell: navigationShell);
          },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/lists',
              builder: (BuildContext context, GoRouterState state) =>
                  const Placeholder(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/products',
              builder: (BuildContext context, GoRouterState state) =>
                  ProductsPage(bloc: Provider.of<ProductBloc>(context)),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) =>
                  const Placeholder(),
            ),
          ],
        ),
      ],
      navigatorContainerBuilder:
          (
            BuildContext context,
            StatefulNavigationShell navigationShell,
            List<Widget> children,
          ) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: children[navigationShell.currentIndex],
            );
          },
    ),
  ],
);

void main() async {
  await Hive.initFlutter('.');
  Hive.registerAdapters();

  await Hive.openBox<ShoppingListModel>(StringConstants.shoppingListBox);
  await Hive.openBox<ProductModel>(StringConstants.productBox);
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ShoppingListBloc()..initialize()),
        Provider<Database<ProductModel>>(create: (_) => HiveDatabase()),
        ProxyProvider<Database<ProductModel>, DatabaseRepository<Product>>(
          update: (BuildContext context, Database<ProductModel> database, _) =>
              ProductRepository(database: database),
        ),
        ProxyProvider<DatabaseRepository<Product>, ProductBloc>(
          update:
              (
                BuildContext context,
                DatabaseRepository<Product> repository,
                _,
              ) => ProductBloc(repository: repository)..initialize(),
        ),
      ],
      child: MaterialApp.router(routerConfig: _router),
    ),
  );
}
