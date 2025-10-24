import 'package:v04/models/models.dart'; // Importerar alla modeller
import 'input_helper.dart' as input;
import 'package:v04/managers/hero_data_manager.dart';

Future<void> manualAddHero(HeroDataManager manager) async {
  print('\n --- Lägg till hjälte manuellt ---');
  //OBS hur ordnar vi med ID? readInt bättre... API har unika ID:n. Bool "from api" samt "from manual"? 
  final id = input.readInt('Ange ID (1001-2000): ', min: 1001, max: 2000);
  final name = input.readString('Ange hjältenamn: ');
  final intelligence = input.readOptionalInt('Ange intelligens (0-100): ', min: 0, max: 100);
  final strength = input.readOptionalInt('Ange styrka (0-100): ', min: 0, max: 100);
  final speed = input.readOptionalInt('Ange snabbhet (0-100): ', min: 0, max: 100);
  final durability = input.readOptionalInt('Ange Uthållighet (0-100): ', min: 0, max: 100);
  final power = input.readOptionalInt('Ange kraft (0-100): ', min: 0, max: 100);
  final combat = input.readOptionalInt('Ange skicklighet (0-100): ', min: 0, max: 100);
  final alignment = input.readOptions('Ange alignment:', ['good', 'neutral', 'bad']);

  final powerstats = Powerstats(
    intelligence: intelligence,
    strength: strength,
    speed: speed,
    durability: durability,
    power: power,
    combat: combat,
  );

  final hero = HeroModel(
    id: id,
    name: name,
    powerstats: powerstats,
    biography: Biography(alignment: alignment)
  );

  final savedHero = await HeroDataManager().addHero(hero);
  print('Hjälte tillagd: ${savedHero.name} (id: ${savedHero.id})');
}