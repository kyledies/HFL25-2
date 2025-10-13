import 'package:v02/v02.dart' as v02;
import 'dart:io';

// ignore: slash_for_doc_comments
/**
     * * Viktig Info 
     * ? Frågetecken
     * ! Varning 
     * TODO - Lägg till...
     */

List<Map<String, dynamic>> heroes = []; // Lista för att lagra hjältar

//String? hero Skapar hero == null "?" gör att den kan vara null
// int.parse(number!) "!" gör att den inte kan vara null
void main() {
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
        v02.addHero(heroes);
        break; // bryter loopen efter att ha lagt till hjälte
      case 2:
        v02.showHeroes(heroes);
        break; // bryter loopen efter att ha visat hjältar
      case 3:
        v02.searchHero(heroes);
        break; // bryter loopen efter att ha sökt hjälte
      case 4:
        print('Avslutar programmet.');
        return;
      default: //svarar mot tidigare "else"
        print('Ogiltigt val (icke heltal 1-4).');
    }
  }
}