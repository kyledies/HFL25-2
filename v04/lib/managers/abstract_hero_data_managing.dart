import 'package:v04/models/hero_model.dart';
//Definierar kontraktet för HeroDataManager - vilka metoder den måste implementera
// Abstrakt klass för hantering av lagrad hjältedata. För inhämtning av hjältar via API:t används en separat manager.
abstract class AbstractHeroDataManaging {

  /// Lägg till eller uppdatera en hjälte (matchar på id).
  Future<HeroModel> addHero(HeroModel hero);

// hämtar hela listan med hjältar
  Future<List<HeroModel>> getHeroList();

  // Söker hjältar vars namn innehåller query (case insensitive)
  Future<List<HeroModel>> searchHero(String query);

// Sorterar hjältar på strength (fallande) och returnerar den sorterade listan
 Future<List<HeroModel>> sortHeroesByStrength({bool desc = true});
}