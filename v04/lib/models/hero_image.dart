import '../helpers/json_helper.dart';

class HeroImage {
  final String? url;

  const HeroImage({this.url});

  factory HeroImage.fromJson(JsonMap json) => HeroImage(url: toStr(json['url']));

  JsonMap toJson() => { 'url': url };
}