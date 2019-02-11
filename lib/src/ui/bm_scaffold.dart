import 'package:bm_board/src/blocs/scaffold_bloc.dart';
import 'package:bm_board/src/blocs/scaffold_bloc_provider.dart';
import 'package:bm_board/src/models/scaffold_status.dart';
import 'package:bm_board/src/style/app_style.dart';
import 'package:bm_board/src/ui/blasph_list.dart';
import 'package:flutter/material.dart';

class BMScaffold extends StatelessWidget {
  final scaffoldBloc = ScaffoldBloc();

  @override
  Widget build(BuildContext context) {
    return ScaffoldBlocProvider(
      scaffoldBloc: scaffoldBloc,
      child: StreamBuilder(
        initialData: ScaffoldStatus.empty(),
        stream: scaffoldBloc.scaffoldStatus,
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, AsyncSnapshot<ScaffoldStatus> snapshot) {
    bool _safeMode = snapshot.data.isSafeMode;
    Color _toolbarColor = snapshot.data.toolbarColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BM Board",
          style: TextStyle(
              color: _safeMode
                  ? AppStyle.safe_mode_text_color
                  : AppStyle.pro_mode_text_color),
        ),
        backgroundColor: _toolbarColor,
        actions: <Widget>[
          Switch(
              value: _safeMode,
              activeColor: Colors.black,
              onChanged: (bool value) {
                scaffoldBloc.isSafeMode.add(value);
              }),
        ],
      ),
      body: BlasphList(),
    );
  }
}
