import 'package:v04/models/models.dart'; // Importerar alla modeller
import 'input_helper.dart' as input;
import 'package:v04/managers/hero_data_manager.dart';

Future<void> manualAddHero(HeroDataManager manager) async {
  print('\n --- Lägg till hjälte manuellt ---');
  //OBS hur ordnar vi med ID? readInt bättre... API har unika ID:n. Bool "from api" samt "from manual"? 
  final id = input.readString('Ange hjälte-ID: '); 
  final name = input.readString('Ange hjältenamn: ');
  final intelligence = input.readOptionalInt('Ange intelligens (0-100): ', min: 0, max: 100);
  final strength = input.readOptionalInt('Ange styrka (0-100): ', min: 0, max: 100);
  final speed = input.readOptionalInt('Ange snabbhet (0-100): ', min: 0, max: 100);

  final powerstats = Powerstats(
    intelligence: intelligence,
    strength: strength,
    speed: speed,
  );

  final hero = HeroModel(
    id: id,
    name: name,
    powerstats: powerstats,
  );

  final savedHero = await HeroDataManager().addHero(hero);
  print('✅ Hjälte tillagd: ${savedHero.name} (id: ${savedHero.id})');
}