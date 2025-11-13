import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_poc/core/colors.dart';
import 'package:hive_ce_poc/presentation/widgets/custom_bottom_navigation_bar.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHelper.primary,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  color: ColorHelper.background,
                  height: 45,
                  width: 45,
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Shopping Helper',
                style: TextStyle(
                  color: ColorHelper.background,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ColoredBox(color: ColorHelper.background, child: navigationShell),
      bottomNavigationBar: CustomBottomNavigationBar(
        color: ColorHelper.primary,
        onAddCallback: () {},
      ),
    );
  }
}
