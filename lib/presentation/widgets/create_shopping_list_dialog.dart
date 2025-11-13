import 'package:flutter/material.dart';
import 'package:hive_ce_poc/core/colors.dart';

class CreateShoppingListDialog extends StatefulWidget {
  const CreateShoppingListDialog({super.key, required this.onCreateNew});

  final Function(String name, String description) onCreateNew;

  @override
  State<CreateShoppingListDialog> createState() =>
      _CreateShoppingListDialogState();
}

class _CreateShoppingListDialogState extends State<CreateShoppingListDialog> {
  String listName = '';
  String listDescription = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'New shopping List',
              style: TextStyle(fontSize: 20.0, color: ColorHelper.primary),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (newValue) {
                listName = newValue;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (newValue) {
                listDescription = newValue;
              },
            ),
            const SizedBox(height: 15),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  ColorHelper.primary,
                ),
              ),
              onPressed: () {},
              child: Text('Add', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
