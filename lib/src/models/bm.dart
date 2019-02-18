class BM {
  String name;
  String audioLocation;
  bool blasphemy;
  bool starred = false;

  BM(this.name, this.audioLocation, this.blasphemy);

  BM.fromJson(Map<String, dynamic> json) {
    this.name = json['label'];
    this.audioLocation = json['sound'];
    this.blasphemy = json['blasphemy'];
  }

  Map<String, dynamic> toJson() =>
      {
        'label': name,
        'sound': audioLocation,
        'blasphemy': blasphemy
      };
}
