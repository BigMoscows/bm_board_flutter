class BM {
  String name;
  String audioLocation;
  bool blasphemy;

  BM(this.name, this.audioLocation, this.blasphemy);

  BM.fromJson(Map json) {
    this.name = json['label'];
    this.audioLocation = json['sound'];
    this.blasphemy = json['blasphemy'];
  }
}
