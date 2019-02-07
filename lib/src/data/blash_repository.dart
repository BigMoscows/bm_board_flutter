import 'package:bm_board/src/data/blasph_source.dart';
import 'package:bm_board/src/models/bm.dart';

class BlasphRepository {

  final blasphProvider = BlasphProvider();

  Future<List<BM>> fetchBlasph() => blasphProvider.fetchBlasph();

}