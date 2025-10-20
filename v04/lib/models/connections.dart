import '../helpers/json_helper.dart';

class Connections {
  final String? groupAffiliation;
  final String? relatives;

  const Connections({this.groupAffiliation, this.relatives});

  factory Connections.fromJson(JsonMap json) => Connections(
    groupAffiliation: toStr(json['group-affiliation']),
    relatives:        toStr(json['relatives']),
  );

  JsonMap toJson() => {
    'group-affiliation': groupAffiliation,
    'relatives': relatives,
  };
}