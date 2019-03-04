import 'package:firebase_database/firebase_database.dart';

class BMStatAggregate {
  String key;
  DateTime lastPlay;
  bool isBlasphemy;
  int playCount;


  BMStatAggregate(this.key, this.lastPlay, this.isBlasphemy, this.playCount);

  toJson() {
    return {
      "last_play": lastPlay.millisecondsSinceEpoch,
      "is_blaspemy": isBlasphemy,
      "play_count": playCount
    };
  }

  BMStatAggregate.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        lastPlay = new DateTime.fromMillisecondsSinceEpoch(snapshot.value["last_play"]),
        playCount = snapshot.value["play_count"].toInt(),
        isBlasphemy = snapshot.value["is_blaspemy"];

}
