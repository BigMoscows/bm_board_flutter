import 'dart:async';

import 'package:bm_board/src/data/blash_repository.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:bm_board/src/models/scaffold_status.dart';
import 'package:bm_board/src/style/app_style.dart';

class TilesBloc {

  // Stream Controllers that controls the input and output streams
  final _scaffoldStatusController = StreamController<ScaffoldStatus>();
  final _changeStatusController = StreamController<bool>();
  final _blasphController = StreamController<List<BM>>();

  // Input
  Sink<bool> get isSafeMode => _changeStatusController.sink;

  // Output
  Stream<ScaffoldStatus> get scaffoldStatus => _scaffoldStatusController.stream;
  Stream<List<BM>> get blasphStream => _blasphController.stream;

  List<BM> _allItems;
  List<BM> _safeItems;

  final _repository = BlasphRepository();

  TilesBloc() {
    _changeStatusController.stream.listen(_handleStatus);
    fetchFirstBlasph();
  }

  void dispose() {
    _scaffoldStatusController.close();
    _changeStatusController.close();
    _blasphController.close();
  }

  // Load Blasphemies from json and add the sounds to the device cache
  // The app starts in safe mode
  void fetchFirstBlasph() {
    _repository.fetchBlasph().then((result) {
      _allItems = result;
      _safeItems = result.where((i) => !i.blasphemy).toList();

      _repository.loadSounds(_allItems).then((value) {
        if (value.isNotEmpty) {
          _blasphController.add(_safeItems);
        }
      });
    });
  }

  // Respond to the changes of "safeness"
  // The list should not be null, but more checks are not bad
  void _handleStatus(bool isSafe) {
    ScaffoldStatus scaffoldStatus;
    if (isSafe) {
      scaffoldStatus = ScaffoldStatus(true, AppStyle.safe_mode_status_color);
    } else {
      scaffoldStatus = ScaffoldStatus(false, AppStyle.pro_mode_status_color);
    }

    _scaffoldStatusController.add(scaffoldStatus);

    if (_allItems == null) {
      _repository.fetchBlasph().then((result) {
        _allItems = result;
        _safeItems = result.where((i) => !i.blasphemy).toList();
        if (isSafe) {
          _blasphController.add(_safeItems);
        } else {
          _blasphController.add(_allItems);
        }
      });
    } else {
      if (isSafe) {
        _blasphController.add(_safeItems);
      } else {
        _blasphController.add(_allItems);
      }
    }
  }
}
