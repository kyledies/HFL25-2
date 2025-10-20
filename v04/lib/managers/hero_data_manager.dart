import 'package:v04/managers/abstract_hero_data_managing.dart';
import 'package:v04/models/hero_model.dart';
//Singleton 
final class HeroDataManager implements AbstractHeroDataManaging {
  //singleton
  HeroDataManager._internal(); // Privat konstruktor
  static final HeroDataManager _instance = HeroDataManager._internal();
  factory HeroDataManager() => _instance; // Fabrikskonstruktor som alltid returnerar samma instans

  // Intern lista för att lagra hjältar
  final List<HeroModel> _heroes = [];
  
  int _indexOfId(String id) {
    return _heroes.indexWhere((hero) => hero.id == id);
  }

  @override
  Future<void> addHero(HeroModel hero) async {
    final index = _indexOfId( hero.id);
    if (index >= 0) {
      // Uppdatera befintlig hjälte
      _heroes[index] = hero;
    } else {
      // Lägg till ny hjälte
      _heroes.add(hero);
    }
  }

  @override
  // en future som returnerar en lista med hjältar
  Future<List<HeroModel>> getHeroList() async {
    return List<HeroModel>.from(_heroes); // Returnerar en kopia av listan
  }

  @override
  Future<List<HeroModel>> searchHero(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _heroes.where((hero) => hero.name.toLowerCase().contains(q)).toList();
  }

  @override
  // Använder sort-metoden med en jämförelsefunktion. 
  //*Förstår inte helt...Tar två element a och b - Jämför deras strength. Kika på compareTo i Dart docs..
  //* Om bStrength är större än aStrength → compareTo blir positivt → a efter b
  //* Om aStrength är större än bStrength → compareTo blir negativt → a före b 
  //* Alla par jämförs i listan tills den är sorterad
  Future<List<HeroModel>> sortHeroesByStrength({bool desc = true}) async {
    final List<HeroModel> sorted = List<HeroModel>.from(_heroes);
    sorted.sort((a, b) {
      // a.powerstats?.strength -> tillåter strength att vara null
      // "?? 0" -> Om strength är null, använd 0 som defaultvärde, dvs aStrength blir 0 istället för null
      // Detta gör att vi kan jämföra även om strength är null
      final aStrength = a.powerstats?.strength ?? 0;
      final bStrength = b.powerstats?.strength ?? 0;
      // Om desc är true, sortera fallande (första uttrycket), annars stigande (andra uttrycket)
      return desc ? bStrength.compareTo(aStrength) : aStrength.compareTo(bStrength);
    });
    return sorted;
  }

  void clear() => _heroes.clear();
}