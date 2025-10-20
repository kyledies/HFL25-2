// Hämtat några hjältar från superheroapi.com och sparat i en test-fil för att kunna testa vår HeroModel.fromJson
import 'dart:convert';
import 'package:v04/helpers/json_helper.dart';
import 'package:v04/models/hero_model.dart';
import 'package:v04/managers/hero_data_manager.dart';

Future<void> main() async {
  final hero1 = '''
{
  "response": "success",
  "id": "1",
  "name": "A-Bomb",
  "powerstats": {
    "intelligence": "38",
    "strength": "100",
    "speed": "17",
    "durability": "80",
    "power": "24",
    "combat": "64"
  },
  "biography": {
    "full-name": "Richard Milhouse Jones",
    "alter-egos": "No alter egos found.",
    "aliases": [
      "Rick Jones"
    ],
    "place-of-birth": "Scarsdale, Arizona",
    "first-appearance": "Hulk Vol 2 #2 (April, 2008) (as A-Bomb)",
    "publisher": "Marvel Comics",
    "alignment": "good"
  },
  "appearance": {
    "gender": "Male",
    "race": "Human",
    "height": [
      "6'8",
      "203 cm"
    ],
    "weight": [
      "980 lb",
      "441 kg"
    ],
    "eye-color": "Yellow",
    "hair-color": "No Hair"
  },
  "work": {
    "occupation": "Musician, adventurer, author; formerly talk show host",
    "base": "-"
  },
  "connections": {
    "group-affiliation": "Hulk Family; Excelsior (sponsor), Avengers (honorary member); formerly partner of the Hulk, Captain America and Captain Marvel; Teen Brigade; ally of Rom",
    "relatives": "Marlo Chandler-Jones (wife); Polly (aunt); Mrs. Chandler (mother-in-law); Keith Chandler, Ray Chandler, three unidentified others (brothers-in-law); unidentified father (deceased); Jackie Shorr (alleged mother; unconfirmed)"
  },
  "image": {
    "url": "https://www.superherodb.com/pictures2/portraits/10/100/10060.jpg"
  }
}
''';

  final hero2 = '''
{
  "response": "success",
  "id": "100",
  "name": "Black Flash",
  "powerstats": {
    "intelligence": "44",
    "strength": "10",
    "speed": "100",
    "durability": "80",
    "power": "100",
    "combat": "30"
  },
  "biography": {
    "full-name": "",
    "alter-egos": "No alter egos found.",
    "aliases": [
      "Barry Allen",
      "Flashback",
      "Slow Lightning",
      "Black Racer",
      "Death Flash",
      "God of Death"
    ],
    "place-of-birth": "-",
    "first-appearance": "Flash Vol 2 #138",
    "publisher": "DC Comics",
    "alignment": "neutral"
  },
  "appearance": {
    "gender": "Male",
    "race": "God / Eternal",
    "height": [
      "-",
      "0 cm"
    ],
    "weight": [
      "- lb",
      "0 kg"
    ],
    "eye-color": "-",
    "hair-color": "-"
  },
  "work": {
    "occupation": "-",
    "base": "-"
  },
  "connections": {
    "group-affiliation": "-",
    "relatives": "-"
  },
  "image": {
    "url": "https://www.superherodb.com/pictures2/portraits/10/100/10831.jpg"
  }
}
''';

  final hero3 = '''
{
  "response": "success",
  "id": "500",
  "name": "Omega Red",
  "powerstats": {
    "intelligence": "null",
    "strength": "61",
    "speed": "null",
    "durability": "null",
    "power": "null",
    "combat": "null"
  },
  "biography": {
    "full-name": "Arkady Gregorivich",
    "alter-egos": "No alter egos found.",
    "aliases": [
      "Arkady Rossovich",
      "Vasyliev Arkady"
    ],
    "place-of-birth": "-",
    "first-appearance": "-",
    "publisher": "Marvel Comics",
    "alignment": "bad"
  },
  "appearance": {
    "gender": "Male",
    "race": "null",
    "height": [
      "6'11",
      "211 cm"
    ],
    "weight": [
      "425 lb",
      "191 kg"
    ],
    "eye-color": "Red",
    "hair-color": "Blond"
  },
  "work": {
    "occupation": "Crimelord; former mercenary, KGB agent",
    "base": "-"
  },
  "connections": {
    "group-affiliation": "Red Mafia (kingpin); former employee of Sabretooth, The General, Ivan Pushkin, and Matsu'o Tsurayaba; formerly KGB",
    "relatives": "-"
  },
  "image": {
    "url": "https://www.superherodb.com/pictures2/portraits/10/100/208.jpg"
  }
} 
''';

  // Dekodar JSON strängar till Map<String, dynamic>
  final map1 = jsonDecode(hero1) as JsonMap; //Map<String, dynamic>;
  final map2 = jsonDecode(hero2) as JsonMap;
  final map3 = jsonDecode(hero3) as JsonMap;

  // Skapar HeroModel objekt från mapparna
  final h1 = HeroModel.fromJson(map1);
  final h2 = HeroModel.fromJson(map2);
  final h3 = HeroModel.fromJson(map3);

  // Skriver ut några fält för att verifiera
  print('Hero 1: ${h1.name}, Full Name: ${h1.biography?.fullName}, Intelligence: ${h1.powerstats?.intelligence}');
  print('Hero 2: ${h2.name}, Full Name: ${h2.biography?.fullName}, Intelligence: ${h2.powerstats?.intelligence}');
  print('Hero 3: ${h3.name}, Full Name: ${h3.biography?.fullName}, Intelligence: ${h3.powerstats?.intelligence}');
  final repo = HeroDataManager();
  repo.clear(); // valfritt vid omkörning

  // Här används addHero
  await repo.addHero(h1);
  await repo.addHero(h2);
  await repo.addHero(h3);

  // Här används getHeroList
  final all = await repo.getHeroList();
  print('Antal hjältar: ${all.length}');
  for (final h in all) {
    print('- ${h.id}: ${h.name}');
  }

  // Här används searchHero
  final hits = await repo.searchHero('Flash');
  print('Sök "Fl": ${hits.map((e) => e.name).toList()}');

  //här används sortHeroesByStrength
  final sorted = await repo.sortHeroesByStrength(desc: true);
  print('Sorterade på strength (desc): ${sorted.map((e) => '${e.name}(${e.powerstats?.strength ?? 0})').toList()}');
}