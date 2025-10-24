//import 'package:v04/v04.dart' as v04;
import 'dart:io';
import 'package:v04/helpers/input_helper.dart' as input;
import 'package:v04/helpers/manual_add_hero.dart'; //För manuell input
import 'package:v04/helpers/add_by_api.dart';
//import 'package:v04/models/models.dart'; // Importerar alla modeller
import 'package:v04/managers/hero_data_manager.dart'; // <- min HeroDataManager
import 'package:v04/managers/file_storage_manager.dart'; // <- min FileStorageManager
import 'package:v04/managers/network_manager.dart'; // <- min NetworkManager
import 'package:v04/helpers/show_menu.dart';

///**
    //  * * Viktig Info 
    //  * ? Frågetecken
    //  * ! Varning 
    //  * TODO - Lägg till...
    //   * FIXME - Fixa...
    //   */

//Initierar NetworkManager, HeroDataManager, FileStorageManager
final net = NetworkManager();
final manager = HeroDataManager();
final storage = FileStorageManager(path: 'data/heroes.json');

//String? hero Skapar hero == null "?" gör att den kan vara null
// int.parse(number!) "!" gör att den inte kan vara null
void main() async{ 
  // Ladda in från disk vid start
  final loaded = await storage.loadAll();
  for (final h in loaded) {
    await manager.addHero(h); 
  }
  print('Hej och välkommen till Superhjälte-appen!');

  while (true) { 
//     print('Ange val (1-4) eller 5 för att avsluta:');
//     await Future.delayed(Duration(milliseconds: 500)); // liten fördröjning för ögat
//     print('1. Lägg till hjälte manuellt');
//     await Future.delayed(Duration(milliseconds: 400)); 
//     print('2. Lägg till hjälte via API');
//     await Future.delayed(Duration(milliseconds: 300)); 
//     print('3. Visa alla hjältar');
//     await Future.delayed(Duration(milliseconds: 200)); 
//     print('4. Sök hjälte lokalt');
//     await Future.delayed(Duration(milliseconds: 100)); 
//     print('5. Spara och Avsluta'); 
//     await Future.delayed(Duration(milliseconds: 100)); 
//     print('6. Rensa ALL Data');

// //Input från användaren. 
//     final choice = stdin.readLineSync(); // final OK då det sätts varje gång i loopen
//     if (choice == null || choice.trim().isEmpty) {  //Hantera null eller tom inmatning
//       print('Ogiltigt val (tom sträng/null).');
//       continue; // Går tillbaka till början av loopen
//     }
// // Konvertera inmatning till int och hantera felaktig inmatning (icke-numerisk)

//     //* final int? choiceInt <- kan vara null Försöker konvertera till int
//     final choiceInt = int.tryParse(choice.trim()); // Försöker konvertera till int, trimmar whitespace
//     if (choiceInt == null) { 
//       print('Ogiltigt val (icke heltal).');
//       continue; // Går tillbaka till början av loopen
//     }
    await printMainMenu();
    final choice = readMainMenuChoice();

    switch (choice) { //switch-case istället för if-else
      //Lägg till hjälte manuellt
      case 1:
        while (true) {
          await manualAddHero(manager);
          final repeat = input.readOptions('Vill du lägga till en till hjälte?', ['ja', 'nej']);
          if (repeat == 'ja') {
            continue; //vi frågar vidare
          } else {
            break;
          }
        }
      // Lägg till hjälte via API - Ändra till sök och möjlighet att lägga till
      case 2: 
        await addHeroViaApi(net, manager);
        break; // bryter loopen 

      // Visa alla hjältar lokalt
      case 3:
        final list = await manager.getHeroList();
        if (list.isEmpty) {
          print('📝 Inga hjältar ännu.');
        } else {
          for (var i = 0; i < list.length; i++) {
            final h = list[i];
            print('${i + 1}. ${h.name} (id: ${h.id}, Powerstat-snitt: ${h.powerstats?.avg?.toStringAsFixed(2)})');
          }
          print("*** ${list.length} lagrade hjältar printade ovan ***");
        }
        break; // bryter loopen efter att ha sökt hjälte

      // Sök hjälte lokalt
      case 4:
        print('TODO : Sök hjälte lokalt');
        //heroes = await heroDataManager.searchHero(heroes);
        break; // bryter loopen efter att ha sökt hjälte
      
      // Avsluta programmet
      case 5:
        print('Sparar och Avslutar programmet.');
        final all = await manager.getHeroList();
        await storage.saveAll(all);
        return;
      
      // Rensar Lagring 
      case 6:
        final terminator = input.readOptions("ÄR DU SÄKER PÅ ATT DU VILL TA BORT ALL DATA?", ['ja', 'nej']);
        if (terminator == 'ja') {
          await storage.clearAll();
          manager.clear();
          print('All data rensad!');
        } else {
          continue;
        }
      default: //svarar mot tidigare "else"
        print('Ogiltigt val (icke heltal 1-5).');
    }
  }
}
