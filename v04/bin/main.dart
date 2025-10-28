import 'package:v04/helpers/input_helper.dart' as input;
import 'package:v04/helpers/manual_add_hero.dart'; //För manuell input
import 'package:v04/helpers/add_by_api.dart';
import 'package:v04/helpers/ascii_portrait.dart';
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
          print('Inga hjältar ännu.');
        } else {
          //Loopar igenom heroes och printar ut powerstats-snitt
          for (var i = 0; i < list.length; i++) {
            final h = list[i];
            print('${i + 1}. ${h.name} (id: ${h.id}, Powerstat-snitt: ${h.powerstats?.avg?.toStringAsFixed(2)})');
          }
          print("*** ${list.length} lagrade hjältar printade ovan ***");
        }
        break; // bryter loopen efter att ha sökt hjälte

      // Sök hjälte lokalt
      case 4:
        while (true) {
          final searchKey = input.readString("Ange sökterm: ");
          final heroes = await manager.searchHero(searchKey);

          if (heroes.isEmpty) {
            print('Ingen hjälte hittades lokalt med söktermen "$searchKey".');
            final repeat = input.readOptions('Vill du söka igen?', ['ja', 'nej']);
            if (repeat == 'ja') {
              continue;
            } else {
              break;
            }
          } else {
              print('***Hjältar lokalt som matchar söksträng ${searchKey}:');
              for (var i = 0; i < heroes.length; i++) {
                final h = heroes[i];
                print('${i + 1}. ${h.name} (id: ${h.id}, Powerstat-snitt: ${h.powerstats?.avg?.toStringAsFixed(2)})');
              }
                print("*** ${heroes.length} lagrade hjältar printade ovan ***");
              final repeat = input.readOptions('Vill du söka igen?', ['ja', 'nej']);
              if (repeat == 'ja') {
                continue;
              } else {
                break;
              }
            }
        }
             
      // Sortera lokala hjältar på Strength
      case 5:
        final list = await manager.sortHeroesByStrength();
        if (list.isEmpty) {
          print('Inga hjältar ännu.');
        } else {
          //Loopar igenom heroes och printar ut powerstats-snitt
          print('***Hjältar sorterade på STRENGTH:');
          for (var i = 0; i < list.length; i++) {
            final h = list[i];
            print('${i + 1}. ${h.name} (id: ${h.id}, Strength: ${h.powerstats?.strength}, Powerstat-snitt: ${h.powerstats?.avg?.toStringAsFixed(2)})');
          }
          print("*** ${list.length} lagrade hjältar printade ovan ***");
        }
        break; // bryter loopen efter att ha sökt hjälte

      case 6:
        while (true) {
          await showHeroAsciiArt(manager);
          final repeat = input.readOptions('Vill skapa ett till porträtt?', ['ja', 'nej']);
          if (repeat == 'ja') {
            continue; //vi frågar vidare
          } else {
            break;
          }
        } 

      // Avsluta programmet
      case 7:
        print('Sparar och Avslutar programmet.');
        final all = await manager.getHeroList();
        await storage.saveAll(all);
        return;
      
      // Rensar Lagring 
      case 8:
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
