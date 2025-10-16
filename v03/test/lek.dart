//* Slaskfil för att testa kodbitar
//? Final variable - kan inte ändras efter initiering
//? Const variable import 'lib/models/hero_model.dart';- compile-time constant, måste initieras vid deklaration
import 'package:v03/helpers/json_helper.dart';
import 'package:v03/models/hero_model.dart';
import 'dart:convert';
import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:enough_ascii_art/enough_ascii_art.dart' as art1;
// import 'package:ascii_art_converter/ascii_art_converter.dart' as art2;
// import 'package:http/http.dart' as http;

// Future<void> main() async {
//   final url = Uri.parse('https://www.superherodb.com/pictures2/portraits/10/100/639.jpg');

//   final res = await http.get(url);
//   if (res.statusCode != 200) {
//     print('HTTP ${res.statusCode} – kunde inte hämta bilden');
//     return;
//   }

//   final decoded = img.decodeImage(res.bodyBytes);
//   if (decoded == null) {
//     print('Kunde inte decoda bilden.');
//     return;
//   }

//   final ascii1 = art1.convertImage(decoded, maxWidth: 70, invert: true);
//   print('\n--- ASCII ---\n$ascii1\n');

//   final converter = art2.AsciiArtConverter(
//   width: 70,
//   invert: true,
//   charset: art2.CharSet.standart,   // (stavningen “standart” är paketets)
//   colorMode: art2.ColorMode.trueColor, // ansi256, trueColor, prova ColorMode.none om färg strular
// );

// final ascii2 = await converter.convert(res.bodyBytes);
// print('\n--- ASCII 2 ---\n$ascii2\n');


void main() {
  const jsonText = '''
  {
    "id":"70",
    "name":"Batman",
    "powerstats":{"intelligence":"100","strength":"26","speed":"27","durability":"50","power":"47","combat":"100"},
    "biography":{"full-name":"Bruce Wayne","alter-egos":"No alter egos found.","aliases":["Insider","Matches Malone"],"place-of-birth":"Crest Hill, Bristol Township; Gotham County","first-appearance":"Detective Comics #27","publisher":"DC Comics","alignment":"good"},
    "appearance":{"gender":"Male","race":"Human","height":["6'2","188 cm"],"weight":["210 lb","95 kg"],"eye-color":"blue","hair-color":"black"},
    "work":{"occupation":"Businessman","base":"Batcave, Stately Wayne Manor, Gotham City; Hall of Justice, Justice League Watchtower"},
    "connections":{"group-affiliation":"Batman Family, Batman Incorporated, Justice League, Outsiders, Wayne Enterprises, Club of Heroes, formerly White Lantern Corps, Sinestro Corps","relatives":"Damian Wayne (son), Dick Grayson (adopted son), Tim Drake (adopted son), Jason Todd (adopted son), Cassandra Cain (adopted ward)\\nMartha Wayne (mother, deceased), Thomas Wayne (father, deceased), Alfred Pennyworth (former guardian), Roderick Kane (grandfather, deceased), Elizabeth Kane (grandmother, deceased), Nathan Kane (uncle, deceased), Simon Hurt (ancestor), Wayne Family"},
    "image":{"url":"https://www.superherodb.com/pictures2/portraits/10/100/639.jpg"}
  }
  ''';
  //jsonDecode -> Gör {} -> Map<String, dynamic> som vi kan arbeta med i dart
  final map = jsonDecode(jsonText) as JsonMap; //Map<String, dynamic>;
  //print(map);
  print("Fält name efter decode: ${map["name"]}");
  print("Fält powerstats efter decode: ${map["powerstats"]}");

  final hero = HeroModel.fromJson(map);
  
  print(hero.name);                         // Batman
  print(hero.powerstats?.strength); 
  print(hero.biography?.aliases);     // 26 (int?)
  print(hero.appearance?.height);           // ["6'2", "188 cm"]
  // print(jsonEncode(hero.toJson()));         // Tillbaka till JSON
}
