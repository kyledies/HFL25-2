import 'package:v04/managers/hero_data_manager.dart';
import 'package:v04/managers/network_manager.dart';
import 'input_helper.dart' as input;
//import 'package:v04/models/models.dart';

// Lägg till hjälte via API
Future<void> addHeroViaApi(NetworkManager net, HeroDataManager manager) async {
  print('\n --- Lägg till hjälte via API ---');
  while (true) {
    final searchKey = input.readString('Ange sökterm: ');
    final heroes = await net.fetchHeroModel(searchKey); //Returnerar List<HeroModel>
    if (heroes.isEmpty) {
      print('Ingen hjälte hittades med söktermen "$searchKey".');
      final repeat = input.readOptions('Vill du söka igen?', ['ja', 'nej']);
      if (repeat == 'ja') {
        continue; //vi frågar vidare
      } else {
        return;
      }
    }
    //Vid enbart en träff - Lägg till eller 
    if (heroes.length == 1) {
      print('Söktermen matchade en hjälte: ${heroes[0].name} (id: ${heroes[0].id}).');
      final choice = input.readOptions('Vill du lägga till ${heroes[0].name}?', ['ja', 'nej']);
      if (choice == "nej") {
        print('Avbrutet!');
        return;
      } 
      else {
        await manager.addHero(heroes[0]);
        print('✅ Lade till: ${heroes[0].name} (id=${heroes[0].id})');
        final repeat = input.readOptions('Vill du söka igen?', ['ja', 'nej']);
        if (repeat == 'ja') {
            continue; //vi frågar vidare
        } else {
          return;
        } 
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
          print('***** Välj: ***** \n"1" - spara första träffen.\n"2" - spara ALLA träffar.\n"q" - Avbryt! \n"s" - Sök igen!');
          final choice = input.readOptions('Ange ditt val?', ['1', '2', 'q', 's']);
          //checkar av svar
          if (choice == 'q') {
          print('Avbrutet.');
          return;
        }

        if (choice == 's') {
          continue;
        }

        if (choice == '1') {
          final first = heroes.first;
          await manager.addHero(first);
          print('✅ Lade till: ${first.name} (id=${first.id})');
          final repeat = input.readOptions('Vill du söka igen?', ['ja', 'nej']);
          if (repeat == 'ja') {
            continue; //vi frågar vidare
          } else {
            return;
          } 
        }

        // choice == 'alla'
        for (final h in heroes) {
          await manager.addHero(h);
        }
        print('✅ Lade till ALLA (${heroes.length}) hjältar.');
        final repeat = input.readOptions('Vill du söka igen?', ['ja', 'nej']);
        if (repeat == 'ja') {
          continue; //vi frågar vidare
        } else {
          return;
        }
      }  
    }
  // Konvertera varje träff till HeroModel
}