import 'dart:async';
import 'dart:math';

import 'package:bm_board/src/data/blasph_repository.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:bm_board/src/models/scaffold_status.dart';
import 'package:bm_board/src/style/app_style.dart';
import 'package:rxdart/rxdart.dart';


class TilesBloc {
  // Stream Controllers that controls the input and output streams
  final _scaffoldStatusController = StreamController<ScaffoldStatus>();
  final _changeStatusController = StreamController<bool>();
  final _blasphController = StreamController<List<BM>>.broadcast();
  final _starController = StreamController<BM>();
  final _unstarController = StreamController<BM>();
  // Behaviour subject streams the last element to the new listeners
  final _starredBlasphController = BehaviorSubject<List<BM>>();

  // Input
  Sink<bool> get isSafeMode => _changeStatusController.sink;
  Sink<BM> get starBlasph => _starController.sink;
  Sink<BM> get unstarBlasph => _unstarController.sink;

  // Output
  Stream<ScaffoldStatus> get scaffoldStatus => _scaffoldStatusController.stream;
  Stream<List<BM>> get blasphStream => _blasphController.stream;
  Stream<List<BM>> get starredBlasphStream => _starredBlasphController.stream;

  // Home List
  List<BM> _allItems;
  List<BM> _safeItems;

  // Starred List
  List<BM> _allStarredItems;
  List<BM> _safeStarredItems;

  bool _safeModeEnabled;

  final _repository = BlasphRepository();

  TilesBloc() {
    _changeStatusController.stream.listen(_handleStatus);
    _starController.stream.listen(_starBlasph);
    _unstarController.stream.listen(_unstarBlasph);
    fetchFirstBlasph();
  }

  void dispose() {
    _scaffoldStatusController.close();
    _changeStatusController.close();
    _blasphController.close();
    _starController.close();
    _unstarController.close();
    _starredBlasphController.close();
  }

  // Load Blasphemies from json and add the sounds to the device cache
  // The app starts in safe mode
  void fetchFirstBlasph() {

    _safeModeEnabled = true;

    _repository.fetchBlasph().then((result) {

      result.sort((a, b) => a.name.compareTo(b.name));
      
      _allItems = result;

      // Fetch the starred items from the disk
      _repository.getStarredBlasphs().then((starResult) {
        _allStarredItems = starResult;
        _safeStarredItems = starResult.where((i) => !i.blasphemy).toList();

        // Fill the star if present in the starred
        for (BM blasph in _allStarredItems) {
          var item = _allItems.firstWhere((it) => it.name == blasph.name);
          item.starred = true;
        }

        _safeItems = result.where((i) => !i.blasphemy).toList();
        _repository.loadSounds(_allItems).then((value) {
          if (value.isNotEmpty) {
            _blasphController.add(_safeItems);
            _starredBlasphController.add(_safeStarredItems);
          }
        });
      });
    });
  }

  // Respond to the changes of "safeness"
  // The list should not be null, but more checks are not bad
  void _handleStatus(bool isSafe) {

    _safeModeEnabled = isSafe;

    ScaffoldStatus scaffoldStatus;
    if (isSafe) {
      scaffoldStatus = ScaffoldStatus(true, AppStyle.safe_mode_status_color);
    } else {
      scaffoldStatus = ScaffoldStatus(false, AppStyle.pro_mode_status_color);
    }

    _scaffoldStatusController.add(scaffoldStatus);

    if (_allItems == null) {
      fetchFirstBlasph();
    } else {
      if (isSafe) {
        _blasphController.add(_safeItems);
        _starredBlasphController.add(_safeStarredItems);
      } else {
        _blasphController.add(_allItems);
        _starredBlasphController.add(_allStarredItems);
      }
    }
  }

  // Get a random blasph
  BM getRandomBlasph(bool isSafe, int currentIndex) {
    var randomGen = new Random();
    if (currentIndex == 0) {
      if (isSafe) {
        var randomIndex = randomGen.nextInt(_safeItems.length);
        return _safeItems[randomIndex];
      } else {
        var randomIndex = randomGen.nextInt(_allItems.length);
        return _allItems[randomIndex];
      }
    } else {
      if (isSafe) {
        var randomIndex = randomGen.nextInt(_safeStarredItems.length);
        return _safeStarredItems[randomIndex];
      } else {
        var randomIndex = randomGen.nextInt(_allStarredItems.length);
        return _allStarredItems[randomIndex];
      }
    }
  }

  void _starBlasph(BM blasph) {

    blasph.starred = true;

    _allStarredItems.add(blasph);

    if (!blasph.blasphemy) {
      _safeStarredItems.add(blasph);
    }

    if (_safeModeEnabled) {
      _starredBlasphController.add(_safeStarredItems);
      _blasphController.add(_safeItems);
    } else {
      _starredBlasphController.add(_allStarredItems);
      _blasphController.add(_allItems);
    }

    // save the value on the disk
    _repository.saveStarredBlasphs(_allStarredItems);
  }

  void _unstarBlasph(BM blasph) {

    blasph.starred = false;

    // Clear from starred list
    var starItem = _allStarredItems.firstWhere((it) => it.name == blasph.name);
    _allStarredItems.remove(starItem);

    if (!blasph.blasphemy) {
      var item = _safeStarredItems.firstWhere((it) => it.name == blasph.name);
      _safeStarredItems.remove(item);
    }

    if (_safeModeEnabled) {
      _starredBlasphController.add(_safeStarredItems);
    } else {
      _starredBlasphController.add(_allStarredItems);
    }

    // Change value on general list
    var item = _allItems.firstWhere((it) => it.name == blasph.name);
    item.starred = false;

    if (!blasph.blasphemy) {
      var item = _safeItems.firstWhere((it) => it.name == blasph.name);
      item.starred = false;
    }

    if (_safeModeEnabled) {
      _blasphController.add(_safeItems);
    } else {
      _blasphController.add(_allItems);
    }

    // save the value on the disk
    _repository.saveStarredBlasphs(_allStarredItems);

  }


}
