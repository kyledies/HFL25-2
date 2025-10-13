import 'appearance.dart';
import 'biography.dart';
import 'connections.dart';
import 'hero_image.dart';
import 'powerstats.dart';
import 'work.dart';


class HeroModel {
  final String id;
  final String name; //ID och name är req till en början...
  final Powerstats? powerstats;
  final Biography? biography;
  final Appearance? appearance;
  final Work? work;
  final Connections? connections;
  final HeroImage? heroImage;

  const HeroModel({
    required this.id,
    required this.name,
    this.powerstats,
    this.biography,
    this.appearance,
    this.work,
    this.connections,
    this.heroImage,
  });
}