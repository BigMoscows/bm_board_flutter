import 'package:meta/meta.dart';

class BM {
  final String name;
  final String audioLocation;

  const BM({
    @required this.name,
    @required this.audioLocation,
  })  : assert(name != null),
        assert(audioLocation != null);
}
