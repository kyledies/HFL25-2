import '../helpers/json_helper.dart';

class Work {
  final String? occupation;
  final String? base;

  const Work({this.occupation, this.base});

  factory Work.fromJson(JsonMap json) => Work(
    occupation: toStr(json['occupation']),
    base:       toStr(json['base']),
  );

  JsonMap toJson() => {
    'occupation': occupation,
    'base': base,
  };
}