import 'package:bm_board/src/style/app_style.dart';
import 'package:flutter/material.dart';

class ScaffoldStatus {
  bool isSafeMode;
  Color toolbarColor;

  ScaffoldStatus(this.isSafeMode, this.toolbarColor);

  static ScaffoldStatus empty() {
    return ScaffoldStatus(true, AppStyle.safe_mode_status_color);
  }
}
