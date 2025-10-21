import 'package:v04/v04.dart' as v04;
import 'dart:io';
import 'package:v04/helpers/input_helper.dart' as input;
import 'package:v04/managers/hero_data_manager.dart';
import 'package:v04/models/models.dart';
import 'package:v04/managers/network_manager.dart'; // <- min NetworkManager
// -> https://superheroapi.com/api/$API_KEY/search/$character ignore: slash_for_doc_comments
/**
     * * Viktig Info 
     * ? Frågetecken
     * ! Varning 
     * TODO - Lägg till...
      * FIXME - Fixa...
      */

final net = NetworkManager();
final heroDataManager = HeroDataManager();

//String? hero Skapar hero == null "?" gör att den kan vara null
// int.parse(number!) "!" gör att den inte kan vara null
void main() async{ 
  List <Map<String, dynamic>> heroes = [];

  print('Hej och välkommen till Superhjälte-appen!');

  // 🔎 Snabbtest av nätverket
  final testHero = await net.fetchHeroModel('Batman');
  print('API-test → ${testHero?.name ?? "ingen träff"}');
  // if heroes == null {
  //   heroes = [];
  // }
  while (true) { 
    print('Ange val (1-3) eller 4 för att avsluta:');
    print('1. Lägg till hjälte');
    print('2. Visa alla hjältar');
    print('3. Sök hjälte');
    print('4. Avsluta');

//Input från användaren. 
    final choice = stdin.readLineSync(); // final OK då det sätts varje gång i loopen
    if (choice == null || choice.trim().isEmpty) {  //Hantera null eller tom inmatning
      print('Ogiltigt val (tom sträng/null).');
      continue; // Går tillbaka till början av loopen
    }
// Konvertera inmatning till int och hantera felaktig inmatning (icke-numerisk)

    //* final int? choiceInt <- kan vara null Försöker konvertera till int
    final choiceInt = int.tryParse(choice.trim()); // Försöker konvertera till int, trimmar whitespace
    if (choiceInt == null) { 
      print('Ogiltigt val (icke heltal).');
      continue; // Går tillbaka till början av loopen
    }
    switch (choiceInt) { //switch-case istället för if-else
      case 1:
        v04.addHero(heroes);
        break; // bryter loopen efter att ha lagt till hjälte
      case 2:
        v04.showHeroes(heroes);
        break; // bryter loopen efter att ha visat hjältar
      case 3:
        v04.searchHero(heroes);
        break; // bryter loopen efter att ha sökt hjälte
      case 4:
        print('Avslutar programmet.');
        return;
      default: //svarar mot tidigare "else"
        print('Ogiltigt val (icke heltal 1-4).');
    }
  }
}