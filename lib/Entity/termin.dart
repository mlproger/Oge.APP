class Termin {
  String word;
  String descriptions;

  Termin({required this.word, required this.descriptions});

  Map<String, dynamic> toJson() => {'word': word, 'descriptions': descriptions};

  static Termin fromJson(Map<String, dynamic> json) =>
      Termin(word: json["word"], descriptions: json["descriptions"]);
}