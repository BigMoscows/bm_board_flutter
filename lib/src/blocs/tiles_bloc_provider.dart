import 'package:bm_board/src/blocs/tiles_bloc.dart';
import 'package:flutter/widgets.dart';

// Used to pass down the reference down the tree
class TilesBlocProvider extends InheritedWidget {
  final TilesBloc tilesBloc;

  TilesBlocProvider({
    Key key,
    TilesBloc tilesBloc,
    Widget child,
  })  : tilesBloc = tilesBloc ?? TilesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TilesBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TilesBlocProvider)
              as TilesBlocProvider)
          .tilesBloc;
}
