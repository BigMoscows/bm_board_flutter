import 'package:bm_board/src/blocs/tiles_bloc.dart';
import 'package:flutter/widgets.dart';

// Used to pass the reference down the tree
class TilesBlocProvider extends InheritedWidget {

  final TilesBloc tilesBloc;

  TilesBlocProvider({
    Key key,
    TilesBloc scaffoldBloc,
    Widget child,
}) : tilesBloc = scaffoldBloc ?? TilesBloc(),
  super(key: key, child: child);

  // If returns true, updates all the depends elements
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TilesBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TilesBlocProvider)
      as TilesBlocProvider)
      .tilesBloc;
}