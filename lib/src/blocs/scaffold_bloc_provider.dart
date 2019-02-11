import 'package:bm_board/src/blocs/scaffold_bloc.dart';
import 'package:flutter/widgets.dart';

///
/// Used to pass the reference down the tree
///
class ScaffoldBlocProvider extends InheritedWidget {

  final ScaffoldBloc scaffoldBloc;

  ScaffoldBlocProvider({
    Key key,
    ScaffoldBloc scaffoldBloc,
    Widget child,
}) : scaffoldBloc = scaffoldBloc ?? ScaffoldBloc(),
  super(key: key, child: child);

  ///
  /// If returns true, updates all the depends elements
  ///
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ScaffoldBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ScaffoldBlocProvider)
      as ScaffoldBlocProvider)
      .scaffoldBloc;
}