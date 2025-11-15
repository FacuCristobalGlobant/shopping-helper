import 'package:flutter/material.dart';

import 'colors.dart';

abstract class ThemeHelper {
  static final shoppingHelperWidgetStateInputBorder =
      WidgetStateInputBorder.resolveWith(
        (_) => OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(width: 3.0, color: ColorHelper.primary),
        ),
      );
}
