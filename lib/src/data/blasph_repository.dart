import 'dart:convert';
import 'dart:io';

import 'package:bm_board/src/data/blasph_source.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:bm_board/src/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlasphRepository {
  // Implement singleton
  // To get back it, simple call: MyClass myObj = new MyClass();
  /// -------
  static final BlasphRepository _singleton = new BlasphRepository._internal();

  factory BlasphRepository() {
    return _singleton;
  }

  BlasphRepository._internal();

  /// -------

  final blasphProvider = BlasphProvider();
  AudioCache player = new AudioCache(prefix: 'audio/');

  // Fetch blasph from the json
  Future<List<BM>> fetchBlasph() => blasphProvider.fetchBlasph();

  // Load sounds in the device cache
  Future<List<File>> loadSounds(List<BM> blasphList) {
    var sounds = List<String>();
    for (final blasph in blasphList) {
      sounds.add(blasph.audioLocation);
    }
    return player.loadAll(sounds);
  }

  void saveStarredBlasphs(List<BM> blasphList) {
    String blasphJson = json.encode(blasphList);
    SharedPreferences.getInstance().then((shared) {
      shared.setString(Constants.starred_blasph_key, blasphJson);
    });
  }

  Future<List<BM>> getStarredBlasphs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String starredJson = prefs.getString(Constants.starred_blasph_key);
    if (starredJson != null) {
      final parsed = json.decode(starredJson).cast<Map<String, dynamic>>();
      return parsed.map<BM>((json) => BM.fromJson(json)).toList();
    } else {
      return List<BM>();
    }
  }
}
