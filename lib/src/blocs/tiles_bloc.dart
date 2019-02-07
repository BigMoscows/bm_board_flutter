import 'dart:async';

import 'package:bm_board/src/data/blash_repository.dart';
import 'package:bm_board/src/models/bm.dart';

class TilesBloc {

  final _repository = BlasphRepository();
  final _blasphController = StreamController<List<BM>>();

  Stream<List<BM>> get blasphStream => _blasphController.stream;

  fetchAllBlasph() async {
    List<BM> bmList = await _repository.fetchBlasph();
    _blasphController.add(bmList);
  }

  dispose() {
    _blasphController.close();
  }
}
