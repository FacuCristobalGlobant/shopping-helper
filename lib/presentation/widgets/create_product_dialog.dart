import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_poc/core/colors.dart';

import '../../domain/entities/product.dart';

class CreateProductDialog extends StatefulWidget {
  const CreateProductDialog({super.key, required this.onCreateNew});

  final Function(Product newProduct) onCreateNew;

  @override
  State<CreateProductDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  String name = '';
  String description = '';
  Category? category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 26.0),
            child: Center(
              child: Text(
                'New product',
                style: TextStyle(fontSize: 24.0, color: ColorHelper.primary, ),
              ),
            ),
          ),

          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: ColorHelper.primaryDark),
              border: WidgetStateInputBorder.resolveWith(
                    (_) => OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorHelper.primary,
                  ),
                ),
              ),
            ),
            onChanged: (newValue) {
              name = newValue;
            },
          ),
          SizedBox(height: 18.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Description',
              border: WidgetStateInputBorder.resolveWith(
                    (_) => OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorHelper.primary,
                  ),
                ),
              ),
            ),
            onChanged: (newValue) {
              description = newValue;
            },
          ),
          SizedBox(height: 18.0),
          DropdownMenu(
            hintText: 'Category',
            inputDecorationTheme: InputDecorationTheme(
              border: WidgetStateInputBorder.resolveWith(
                    (_) => OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: ColorHelper.primary,
                  ),
                ),
              ),
            ),
            enableFilter: true,
            enableSearch: true,
            width: MediaQuery.of(context).size.width * .8,
            dropdownMenuEntries: Category.values
                .map(
                  (element) => DropdownMenuEntry(
                value: element,
                label:
                element.name[0].toUpperCase() +
                    element.name.substring(1).toLowerCase(),
              ),
            )
                .toList(),
            onSelected: (newCategory) {
              setState(() {
                category = newCategory;
              });
            },
          ),
          const SizedBox(height: 15),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                ColorHelper.primary,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: () {
              if (category != null && name != '') {
                widget.onCreateNew(
                  Product(
                    id: 1,
                    name: name,
                    description: description,
                    category: category!,
                  ),
                );
              }
              context.pop();
            },
            child: Text('Add', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
