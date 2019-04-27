class BM {
  String name;
  String audioLocation;
  bool blasphemy;
  bool starred;
  String tag;

  BM(this.name, this.audioLocation, this.blasphemy, this.starred);

  BM.fromJson(Map<String, dynamic> json) {
    this.name = json['label'];
    this.audioLocation = json['sound'];
    this.blasphemy = json['blasphemy'];
    this.starred = json['starred'] ?? false;
    this.tag = json['tag'];
  }

  Map<String, dynamic> toJson() =>
      {
        'label': name,
        'sound': audioLocation,
        'blasphemy': blasphemy,
        'starred': starred,
        'tag': tag
      };
}
