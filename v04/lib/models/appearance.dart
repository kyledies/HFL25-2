import '../helpers/json_helper.dart';

class Appearance {
  final String? gender;
  final String? race;
  final List<String>? height;
  final List<String>? weight;
  final String? eyeColor;
  final String? hairColor;

const Appearance({
    this.gender,
    this.race,
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
  });

  factory Appearance.fromJson(JsonMap json) {
    return Appearance(
      gender:   toStr(json['gender']),
      race:     toStr(json['race']),
      height:   toStrList(json['height']),
      weight:   toStrList(json['weight']),
      eyeColor: toStr(json['eye-color']),
      hairColor:toStr(json['hair-color']),
    );
  }

  JsonMap toJson() => {
    'gender': gender,
    'race': race,
    'height': height,
    'weight': weight,
    'eye-color': eyeColor,
    'hair-color': hairColor,
  };

}