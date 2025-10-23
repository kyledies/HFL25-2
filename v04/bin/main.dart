//import 'package:v04/v04.dart' as v04;
import 'dart:io';
import 'package:v04/helpers/input_helper.dart' as input;
import 'package:v04/helpers/manual_add_hero.dart';
import 'package:v04/managers/hero_data_manager.dart';
import 'package:v04/models/models.dart'; // Importerar alla modeller
import 'package:v04/managers/network_manager.dart'; // <- min NetworkManager

///**
    //  * * Viktig Info 
    //  * ? Frågetecken
    //  * ! Varning 
    //  * TODO - Lägg till...
    //   * FIXME - Fixa...
    //   */

//Initierar NetworkManager och HeroDataManager
final net = NetworkManager();
final heroDataManager = HeroDataManager();


// Lägg till hjälte via API
Future<void> addHeroViaApi() async {
  print('\n --- Lägg till hjälte via API ---');
  final searchKey = input.readString('Ange sökterm: ');
  final heroes = await net.fetchHeroModel(searchKey); //Returnerar List<HeroModel>
  if (heroes.isEmpty) {
    print('Ingen hjälte hittades med söktermen "$searchKey".');
    return;
  }
  //Vid enbart en träff - Lägg till eller 
  if (heroes.length == 1) {
    print('Söktermen matchade en hjälte: ${heroes[0].name} (id: ${heroes[0].id}).');
    final choice = input.readOptions('Vill du lägga till ${heroes[0].name}?', ['JA', 'NEJ']);
    if (choice == "NEJ") {
      print('Avbrutet!');
      return;
    } 
    if (choice == "JA") {
      await heroDataManager.addHero(heroes[0]);
    }
    //Annars har vi fler än en hjälte. Val - Lägg till hjälte 1 2, 
  } else {
      print('Söktermen matchade: ${heroes.length} hjältar!');
      if (heroes.length<6) {
        for (var i = 0; i < heroes.length; i++) {
          print('${i + 1}. ${heroes[i].name} (id=${heroes[i].id})');
        }
      } else {
          print('Här är de fem första träffarna:');
          for (var i = 0; i<5; i++) {
            print('${i + 1}. ${heroes[i].name} (id=${heroes[i].id})');
            }
          print('…och ${heroes.length - 5} till.');
        }
        print('* Välj "ALLA" för att spara alla träffar\n * Välj "FÖRSTA" för att spara första träffen\n Välj "AVBRYT" för att avbryta!');
        final choice = input.readOptions('Ange ditt val?', ['ALLA', 'FÖRSTA', 'AVBRYT']);
        //checkar av svar
        if (choice == 'AVBRYT') {
        print('Avbrutet.');
        return;
      }

      if (choice == 'FÖRSTA') {
        final first = heroes.first;
        await heroDataManager.addHero(first);
        print('✅ Lade till: ${first.name} (id=${first.id})');
        return;
      }

      // choice == 'ALLA'
      for (final h in heroes) {
        await heroDataManager.addHero(h);
      }
      print('✅ Lade till ALLA (${heroes.length}) hjältar.');
      return;
    }  
  // Konvertera varje träff till HeroModel
}

//String? hero Skapar hero == null "?" gör att den kan vara null
// int.parse(number!) "!" gör att den inte kan vara null
void main() async{ 
  List <Map<String, dynamic>> heroes = [];

  print('Hej och välkommen till Superhjälte-appen!');

  while (true) { 
    print('Ange val (1-4) eller 5 för att avsluta:');
    await Future.delayed(Duration(milliseconds: 500)); // liten fördröjning för ögat
    print('1. Lägg till hjälte manuellt');
    await Future.delayed(Duration(milliseconds: 400)); 
    print('2. Lägg till hjälte via API');
    await Future.delayed(Duration(milliseconds: 300)); 
    print('3. Visa alla hjältar');
    await Future.delayed(Duration(milliseconds: 200)); 
    print('4. Sök hjälte lokalt');
    await Future.delayed(Duration(milliseconds: 100)); 
    print('5. Avsluta'); 

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

      //Lägg till hjälte manuellt
      case 1: 
        await manualAddHero(heroDataManager);
        //heroes = await heroDataManager.addHero(heroes);
        break; // bryter loopen efter att ha lagt till hjälte

      // Lägg till hjälte via API - Ändra till sök och möjlighet att lägga till
      case 2: 
        await addHeroViaApi();
        break; // bryter loopen efter att ha visat hjältar

      // Visa alla hjältar lokalt
      case 3:
        final list = await heroDataManager.getHeroList();
        if (list.isEmpty) {
          print('📝 Inga hjältar ännu.');
        } else {
          for (var i = 0; i < list.length; i++) {
            final h = list[i];
            print('${i + 1}. ${h.name} (id: ${h.id})');
          }
        }
        break; // bryter loopen efter att ha sökt hjälte

      // Sök hjälte lokalt
      case 4:
        print('TODO : Sök hjälte lokalt');
        //heroes = await heroDataManager.searchHero(heroes);
        break; // bryter loopen efter att ha sökt hjälte
      
      // Avsluta programmet
      case 5:
        print('Avslutar programmet.');
        return;
      default: //svarar mot tidigare "else"
        print('Ogiltigt val (icke heltal 1-5).');
    }
  }
}
