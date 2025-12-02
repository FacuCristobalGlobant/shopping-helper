import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@Freezed()
abstract class Product with _$Product{
  const factory Product({
    required int id,
    required String name,
    String? description,
    required Category category,
  }) = _Product;
}

final Map<String, IconData> categoriesIcons = {
  'produce': FontAwesomeIcons.carrot,
  'bakery': FontAwesomeIcons.breadSlice,
  'meat': FontAwesomeIcons.drumstickBite,
  'dairy': FontAwesomeIcons.cow,
  'frozen': FontAwesomeIcons.snowflake,
  'snacks': FontAwesomeIcons.cookieBite,
  'beverages': FontAwesomeIcons.wineBottle,
  'household': FontAwesomeIcons.toolbox,
  'cleaning': FontAwesomeIcons.broom,
  'health': FontAwesomeIcons.suitcaseMedical,
  'pets': FontAwesomeIcons.dog,
  'other': FontAwesomeIcons.diceThree,
};

enum Category {
  produce,
  bakery,
  meat,
  dairy,
  frozen,
  snacks,
  beverages,
  household,
  cleaning,
  health,
  pets,
  other,
}
