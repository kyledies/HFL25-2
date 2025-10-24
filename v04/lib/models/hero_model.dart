import 'dart:ffi';

import '../helpers/json_helper.dart';
import 'appearance.dart';
import 'biography.dart';
import 'connections.dart';
import 'hero_image.dart';
import 'powerstats.dart';
import 'work.dart';

/*
  För EGEN förståelse.
  Vi arbetar med json-data: t.ex jsonText = {"id":"70","name":"Batman","powerstats":{"strength":"26", ""intelligence":"100", ...}, "biography":{...}, "appearance":{...}, "work":{...}, "connections":{...}, "image":{"url":"https://..."}}
  1* text/json -> Map
  När vi gör jsonDecode(jsonText) så får vi en map: Map<String, dynamic> där nycklarna är strängar (t.ex "id", "name", "powerstats", ...)
  och värdena är dynamiska (dvs kan vara olika typer, t.ex String för id och name, Map<String, dynamic> för powerstats etc).
  JsonMap = Map<String, dynamic> är ett alias vi skapat i json_helper.dart för att förenkla koden.
  Exempel:
  final map = jsonDecode(jsonText) as JsonMap;  (Map<String, dynamic>)
  print("Fält name efter decode: ${map["name"]}"); -> Vi når värdet "Batman" via nyckeln "name" 
  eller powerstats {strength: 26, intelligence: 100,...} via nyckeln "powerstats" -> toJsonMap(map['powerstats']) för att få Map<String, dynamic> för powerstats.

  2* Map -> Objekt
  final hero = HeroModel.fromJson(map);
  Här använder vi vår factory konstruktor HeroModel.fromJson för att skapa ett HeroModel objekt från map:en.
  Inuti fromJson:
    - Vi hämtar värdena från map:en med hjälp av nycklarna, t.ex toStr(json['name']) för att få namnet som en String.
    - För fält som är objekt själva (t.ex powerstats, biography etc) så hämtar vi först deras map med toJsonMap och
     skickar sedan den mappen till deras respektive fromJson konstruktor, t.ex Powerstats.fromJson(psMap).
    - Vi hanterar null-värden genom att kolla om map:en för ett objekt är null innan vi försöker skapa objektet.

  print(hero.name);                         // Batman
 */ 

class HeroModel {
  final int id;
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

  factory HeroModel.fromJson(JsonMap json) {
    // Vanliga fallgropar: id/name kan saknas -> kasta tydligt fel
    final id = toInt(json['id']);
    final name = toStr(json['name']);
    if (id == null || name == null) {
      throw FormatException('HeroModel requires non-null id and name');
    }
    // För de andra fälten som är objekt själva, kan vara null
    // Hämtar deras map representation med toJsonMap
    final psMap = toJsonMap(json['powerstats']); // {intelligence: 100, strength: 26, speed: 27, durability: 50, power: 47, combat: 100}
    final bioMap = toJsonMap(json['biography']); //{full-name: Bruce Wayne, alter-egos: No alter egos found., aliases: [Insider, Matches Malone],...}
    final appMap = toJsonMap(json['appearance']);
    final workMap = toJsonMap(json['work']);
    final conMap = toJsonMap(json['connections']);
    final imgMap = toJsonMap(json['image']);

    return HeroModel(
      id: id,
      name: name,
      // Nedan har vi under-mappar som kan vara null
      // om psMap är null -> powerstats blir null, annars skapas Powerstats objekt från psMap
      // powerstats: villkor ? om_sant : om_falskt
      powerstats: psMap == null ? null : Powerstats.fromJson(psMap),
      biography:  bioMap == null ? null : Biography.fromJson(bioMap),
      appearance: appMap == null ? null : Appearance.fromJson(appMap),
      work:       workMap == null ? null : Work.fromJson(workMap),
      connections:conMap == null ? null : Connections.fromJson(conMap),
      heroImage:      imgMap == null ? null : HeroImage.fromJson(imgMap),
    );
  }

  //Vid behov att konvertera tillbaka till JSON
  // Använder toJson metoder i de andra modellerna
  JsonMap toJson() => {
    'id': id,
    'name': name,
    'powerstats': powerstats?.toJson(),
    'biography': biography?.toJson(),
    'appearance': appearance?.toJson(),
    'work': work?.toJson(),
    'connections': connections?.toJson(),
    'image': heroImage?.toJson(),
  };
}