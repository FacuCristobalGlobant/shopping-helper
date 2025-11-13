import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce_poc/core/bloc_state.dart';
import 'package:hive_ce_poc/domain/entities/product.dart';
import 'package:hive_ce_poc/presentation/bloc/product_bloc.dart';
import 'package:hive_ce_poc/presentation/widgets/create_product_dialog.dart';

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

  @override
  void initState() {
    widget.bloc.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.bloc.refreshResults();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            cursorColor: ColorHelper.primaryDark,
            decoration: InputDecoration(
              border: WidgetStateInputBorder.resolveWith(
                (_) => OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(
                    width: 3.0,
                    color: ColorHelper.primary,
                  ),
                ),
              ),
              label: Text('Search'),
              labelStyle: TextStyle(
                color: ColorHelper.primaryDark,
              ),

            ),
          ),
        ),
        SizedBox(
          height: 96.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoriesIcons.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorHelper.background,
                        border: BoxBorder.all(
                          color: ColorHelper.primary,
                          width: 3.0,
                        ),
                      ),
                      child: Icon(
                        categoriesIconData[index],
                        color: ColorHelper.primaryDark,
                      ),
                    ),
                  ),
                  Text(
                    categoriesNames[index],
                    style: TextStyle(color: ColorHelper.primary),
                  ),
                ],
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
                child: StreamBuilder(
                  stream: widget.bloc.stream,
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<BlocState> snapshot,
                      ) {
                        if (snapshot.hasData &&
                            snapshot.data is SuccessBlocState<List<Product>>) {
                          final List<Product> results =
                              (snapshot.data as SuccessBlocState<List<Product>>)
                                  .result;
                          return ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Product product = results[index];
                              return ProductListTile(
                                product: product,
                                roundedTop: index == 0,
                                roundedBottom: index == results.length - 1,
                                textColor: ColorHelper.background,
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              'No results',
                              style: TextStyle(color: ColorHelper.primary),
                            ),
                          );
                        }
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

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.product,
    required this.roundedBottom,
    required this.roundedTop,
    required this.textColor,
  });

  final Product product;
  final bool roundedBottom;
  final bool roundedTop;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadiusGeometry.vertical(
      top: roundedTop ? Radius.circular(10.0) : Radius.circular(0.0),
      bottom: roundedBottom ? Radius.circular(10.0) : Radius.circular(0.0),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: roundedTop ? 0.0 : 2.0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: ColorHelper.primary,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(categoriesIcons[product.category.name], color: textColor),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(color: textColor, fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Icon(FontAwesomeIcons.plus, color: textColor),
          ],
        ),
      ),
    );
  }
}
