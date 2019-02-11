import 'package:bm_board/src/blocs/scaffold_bloc.dart';
import 'package:bm_board/src/style/app_theme.dart';
import 'package:bm_board/src/ui/bm_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  // Start the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BM Board',
      theme: appTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final scaffoldBloc = ScaffoldBloc();

  @override
  Widget build(BuildContext context) {
    return BMScaffold();
  }
}
