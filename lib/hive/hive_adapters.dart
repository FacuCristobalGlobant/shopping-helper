import 'package:hive_ce/hive.dart';
import 'package:hive_ce_poc/data/models/product_model.dart';
import 'package:hive_ce_poc/data/models/shopping_list_item_model.dart';
import 'package:hive_ce_poc/data/models/shopping_list_model.dart';
import 'package:hive_ce_poc/data/models/user_settings_model.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';

@GenerateAdapters([
  AdapterSpec<Category>(),
  AdapterSpec<ProductModel>(),
  AdapterSpec<ShoppingListModel>(),
  AdapterSpec<ShoppingListItemModel>(),
  AdapterSpec<UserSettingsModel>(),
])
part 'hive_adapters.g.dart';
