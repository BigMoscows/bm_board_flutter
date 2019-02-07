import 'package:bm_board/src/blocs/tiles_bloc.dart';
import 'package:bm_board/src/blocs/tiles_bloc_provider.dart';
import 'package:bm_board/src/ui/app_theme.dart';
import 'package:bm_board/src/ui/blasph_list.dart';
import 'package:flutter/material.dart';


void main() {

  // Initiate services as bloc
  final tiles = TilesBloc();

  // Start the app
  runApp(MyApp(tiles));
}

class MyApp extends StatelessWidget {

  final TilesBloc tiles;
  MyApp(this.tiles);

  @override
  Widget build(BuildContext context) {
    return TilesBlocProvider(
      tilesBloc: tiles,
      child: MaterialApp(
        title: 'Bloc Complex',
          theme: appTheme,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tilesProvider = TilesBlocProvider.of(context);
    tilesProvider.fetchAllBlasph();
    return Scaffold(
      appBar: AppBar(
        title: Text('BM Board'),
      ),
      body: BlasphList(),
    );
  }
}

