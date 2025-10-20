import '../helpers/json_helper.dart';

class Biography {
  final String? fullName;
  final String? alterEgos;
  final List<String>? aliases;
  final String? placeOfBirth;
  final String? firstAppearance;
  final String? publisher;
  final String? alignment;

  const Biography({
    this.fullName,
    this.alterEgos,
    this.aliases,
    this.placeOfBirth,
    this.firstAppearance,
    this.publisher,
    this.alignment,
  });

  factory Biography.fromJson(JsonMap json) {
    return Biography(
      fullName:        toStr(json['full-name']),
      alterEgos:       toStr(json['alter-egos']),
      aliases:         toStrList(json['aliases']),
      placeOfBirth:    toStr(json['place-of-birth']),
      firstAppearance: toStr(json['first-appearance']),
      publisher:       toStr(json['publisher']),
      alignment:       toStr(json['alignment']),
    );
  }

  JsonMap toJson() => {
    'full-name': fullName,
    'alter-egos': alterEgos,
    'aliases': aliases,
    'place-of-birth': placeOfBirth,
    'first-appearance': firstAppearance,
    'publisher': publisher,
    'alignment': alignment,
  };
}