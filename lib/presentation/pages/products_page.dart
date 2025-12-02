import 'package:flutter/material.dart' hide Action;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce_poc/core/theme_helper.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';
import 'package:hive_ce_poc/presentation/bloc/product_bloc.dart';
import 'package:hive_ce_poc/presentation/widgets/create_product_dialog.dart';

import '../../core/bloc_state.dart';
import '../../core/colors.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.bloc});

  final ProductBloc bloc;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<IconData> categoriesIconData = categoriesIcons.values.toList();
  final List<String> categoriesNames = categoriesIcons.keys.toList();
  final _listStateKey = GlobalKey<AnimatedListState>();
  final _selectedCategories = <String>[];
  final _activeListItems = <Product>[];

  Widget removedItemBuilder({
    required BuildContext context,
    required Animation<double> animation,
    required Product product,
    required bool isFirst,
    required bool isLast,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      child: ProductListTile(
        backgroundColor: ColorHelper.primary,
        onDeletePressed: () {},
        product: product,
        roundedBottom: isLast,
        roundedTop: isFirst,
        textColor: ColorHelper.background,
      ),
    );
  }

  @override
  void initState() {
    _activeListItems.addAll(widget.bloc.filteredProductsList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            cursorColor: ColorHelper.primaryDark,
            decoration: InputDecoration(
              border: ThemeHelper.shoppingHelperWidgetStateInputBorder,
              label: Text('Search'),
              labelStyle: TextStyle(color: ColorHelper.primaryDark),
            ),
            onChanged: (String newValue) {
              widget.bloc.addNameFilter(newValue);
            },
          ),
        ),
        SizedBox(
          height: 96.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoriesIcons.length,
            itemBuilder: (BuildContext context, int index) {
              return CategoryFilterItem(
                categoryName: categoriesNames[index],
                iconData: categoriesIconData[index],
                isSelected: _selectedCategories.contains(
                  categoriesNames[index],
                ),
                onClick: () {
                  if (_selectedCategories.contains(categoriesNames[index])) {
                    _selectedCategories.remove(categoriesNames[index]);
                  } else {
                    _selectedCategories.add(categoriesNames[index]);
                  }
                  widget.bloc.updateCategoriesFilter(categories: _selectedCategories);
                },
              );
            },
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 20.0,
                child: FilledButton(
                  onPressed: () {
                    showBottomSheet(
                      context: context,
                      builder: (context) {
                        return CreateProductDialog(
                          onCreateNew: (Product product) {
                            widget.bloc.addProduct(product);
                          },
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      ColorHelper.primary,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: Text(
                    'Add new product',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: StreamBuilder<BlocState>(
                  initialData: SuccessBlocState(
                    result: widget.bloc.filteredProductsList,
                  ),
                  stream: widget.bloc.filteredProductsStream,
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<BlocState> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          if (snapshot.data
                              is SuccessBlocState<List<Product>>) {
                            final List<Product> filteredProducts =
                                (snapshot.data
                                        as SuccessBlocState<List<Product>>)
                                    .result;
                            if (_activeListItems.isNotEmpty) {
                              for (
                                int index = _activeListItems.length - 1;
                                index >= 0;
                                index--
                              ) {
                                if (!filteredProducts.contains(
                                  _activeListItems[index],
                                )) {
                                  final Product itemToRemove = _activeListItems[index];
                                  _listStateKey.currentState
                                      ?.removeItem(index, (
                                        BuildContext context,
                                        Animation<double> animation,
                                      ) {
                                        return removedItemBuilder(
                                          context: context,
                                          animation: animation,
                                          product: itemToRemove,
                                          isFirst: index == _activeListItems.length - 1,
                                          isLast: index == 0,
                                        );
                                      }, duration: Duration(milliseconds: 200));
                                  _activeListItems.removeAt(index);
                                }
                              }
                            }
                            for (
                              int index = 0;
                              index < filteredProducts.length;
                              index++
                            ) {
                              if (!_activeListItems.contains(
                                filteredProducts[index],
                              )) {
                                _activeListItems.insert(
                                  index,
                                  filteredProducts[index],
                                );
                                _listStateKey.currentState?.insertItem(index);
                              }
                            }
                            return AnimatedList(
                              key: _listStateKey,
                              itemBuilder:
                                  (
                                    BuildContext context,
                                    int index,
                                    Animation<double> animation,
                                  ) {
                                    final product = _activeListItems[index];
                                    return SizeTransition(
                                      sizeFactor: animation,
                                      child: ProductListTile(
                                        key: GlobalKey(),
                                        backgroundColor: ColorHelper.primary,
                                        onDeletePressed: () {
                                          widget.bloc.deleteProduct(product.id);
                                        },
                                        product: product,
                                        roundedTop: index == 0,
                                        roundedBottom:
                                            index ==
                                            filteredProducts.length - 1,
                                        textColor: ColorHelper.background,
                                      ),
                                    );
                                  },
                              initialItemCount: filteredProducts.length,
                            );
                          }
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorHelper.primary,
                          ),
                        );
                      },
                ),
              ),
              SizedBox(height: 18.0),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryFilterItem extends StatefulWidget {
  const CategoryFilterItem({
    super.key,
    required this.categoryName,
    required this.iconData,
    required this.isSelected,
    required this.onClick,
  });

  final String categoryName;
  final IconData iconData;
  final bool isSelected;
  final Function onClick;

  @override
  State<CategoryFilterItem> createState() => _CategoryFilterItemState();
}

class _CategoryFilterItemState extends State<CategoryFilterItem> {
  late bool isSelected;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onClick();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isSelected
                    ? ColorHelper.primary
                    : ColorHelper.background,
                border: BoxBorder.all(color: ColorHelper.primary, width: 3.0),
              ),
              child: Icon(
                widget.iconData,
                color: isSelected
                    ? ColorHelper.background
                    : ColorHelper.primaryDark,
              ),
            ),
          ),
          Text(
            widget.categoryName,
            style: TextStyle(color: ColorHelper.primary),
          ),
        ],
      ),
    );
  }
}

class ProductListTile extends StatefulWidget {
  const ProductListTile({
    super.key,
    required this.backgroundColor,
    required this.onDeletePressed,
    required this.product,
    required this.roundedBottom,
    required this.roundedTop,
    required this.textColor,
  });

  final Color backgroundColor;
  final Function? onDeletePressed;
  final Product product;
  final bool roundedBottom;
  final bool roundedTop;
  final Color textColor;

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  bool areOptionsVisible = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadiusGeometry.vertical(
      top: widget.roundedTop ? Radius.circular(10.0) : Radius.circular(0.0),
      bottom: widget.roundedBottom
          ? Radius.circular(10.0)
          : Radius.circular(0.0),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: widget.roundedTop ? 0.0 : 2.0,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            areOptionsVisible = !areOptionsVisible;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: widget.backgroundColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      categoriesIcons[widget.product.category.name],
                      color: widget.textColor,
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      height: 40.0,
                      width: 1.0,
                      color: ColorHelper.background,
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: areOptionsVisible ? 0.0 : 1.0,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: widget.textColor,
                          ),
                        ),
                        Icon(FontAwesomeIcons.minus, color: widget.textColor),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                color: ColorHelper.background,
                duration: Duration(milliseconds: 200),
                height: areOptionsVisible ? 70 : 0,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: areOptionsVisible ? 1 : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 2.0,
                                color: ColorHelper.primaryDark,
                              ),
                            ),
                            child: Text(
                              'Add to list',
                              style: TextStyle(color: ColorHelper.primaryDark),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.onDeletePressed!();
                          setState(() {
                            areOptionsVisible = false;
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          size: 16.0,
                          color: ColorHelper.primaryDark,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.pencil,
                          size: 16.0,
                          color: ColorHelper.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
