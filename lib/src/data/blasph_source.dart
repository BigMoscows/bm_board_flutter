import 'dart:async';
import 'dart:convert';

import 'package:bm_board/src/models/bm.dart';
import 'package:flutter/services.dart' show rootBundle;

class BlasphProvider {

  Future<List<BM>> fetchBlasph() async {
    // Load data from assets.
    // This can be a network call
    String responseBody = await rootBundle.loadString('assets/audio_data.json');

    // Parse the results
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<BM>((json) => BM.fromJson(json)).toList();
  }

}