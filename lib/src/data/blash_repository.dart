import 'dart:io';

import 'package:bm_board/src/data/blasph_source.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:audioplayers/audio_cache.dart';

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
}
