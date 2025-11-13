import 'package:flutter/material.dart';
import 'package:hive_ce_poc/presentation/bloc/shopping_list_bloc.dart';
import 'package:provider/provider.dart';

import '../../core/bloc_state.dart';
import '../../core/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ShoppingListBloc bloc, _) {
        return Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data is SuccessBlocState) {
                      return Center(child: Text('success!'));
                    } else {
                      return Center(child: Text('empty'));
                    }
                  } else {
                    return Center(
                      child: Text(
                        'No lists selected',
                        style: TextStyle(color: ColorHelper.primary),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
