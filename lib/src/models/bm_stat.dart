class BMStat {
  DateTime dateTime;
  String blasphemy;
  bool fromRandom;
  bool isBlasphemy;


  BMStat(this.dateTime, this.blasphemy, this.fromRandom, this.isBlasphemy);

  toJson() {
    return {
      "timestamp": dateTime.millisecondsSinceEpoch,
      "blasphemy": blasphemy,
      "from_random": fromRandom,
      "is_blaspemy": isBlasphemy
    };
  }
}