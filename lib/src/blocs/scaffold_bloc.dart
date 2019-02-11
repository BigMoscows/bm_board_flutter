import 'dart:async';

import 'package:bm_board/src/models/scaffold_status.dart';
import 'package:bm_board/src/style/app_style.dart';

class ScaffoldBloc {

  final _scaffoldStatusController = StreamController<ScaffoldStatus>();
  final _changeStatusController = StreamController<bool>();

  Stream<ScaffoldStatus> get scaffoldStatus => _scaffoldStatusController.stream;
  Sink<bool> get isSafeMode => _changeStatusController.sink;

  void dispose() {
    _scaffoldStatusController.close();
    _changeStatusController.close();
  }

  ScaffoldBloc() {
    _changeStatusController.stream.listen(_handleStatus);
  }

  void _handleStatus(bool isSafe) {

    ScaffoldStatus scaffoldStatus;
    if (isSafe) {
      scaffoldStatus = ScaffoldStatus(true, AppStyle.safe_mode_status_color);
    } else {
      scaffoldStatus = ScaffoldStatus(false, AppStyle.pro_mode_status_color);
    }

    _scaffoldStatusController.add(scaffoldStatus);
  }

}