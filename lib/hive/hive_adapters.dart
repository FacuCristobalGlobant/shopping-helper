import 'package:hive_ce/hive.dart';
import 'package:hive_ce_poc/data/models/shopping_list_model.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';
import 'package:hive_ce_poc/domain/entities/shopping_list.dart';
import 'package:hive_ce_poc/domain/entities/user_settings.dart';

import '../data/models/product_model.dart';
import '../data/models/shopping_list_item_model.dart';

@GenerateAdapters([
  AdapterSpec<ShoppingListModel>(),
  AdapterSpec<ShoppingListItemModel>(),
  AdapterSpec<ProductModel>(),
  AdapterSpec<UserSettings>(),
  AdapterSpec<Category>(),
])
part 'hive_adapters.g.dart';
