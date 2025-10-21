import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:v04/models/hero_model.dart';

// Definierar kontraktet för NetworkManager - vilka metoder den måste implementera
abstract class NetworkServiceManaging {
  Future<List<Map<String, dynamic>>?> fetchHero(String heroName);
  Future<HeroModel?> fetchHeroModel(String heroName);
}

class NetworkManager implements NetworkServiceManaging {
  //singleton
  NetworkManager._internal(); // Privat konstruktor
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance; // Fabrikskonstruktor som alltid returnerar samma instans

  final DotEnv env = DotEnv()..load();
    String get baseUrl {
      final envApiKey = env['API_KEY'];
      if (envApiKey == null || envApiKey.isEmpty) {
        throw Exception('API_KEY Saknas.');
      } else {
        return 'https://superheroapi.com/api/$envApiKey';
      }
    }

  @override
  Future <List<Map<String, dynamic>>?> fetchHero(String heroName) async {
    // Implementera nätverksanrop för att hämta hjältedata som en karta
    final url = '$baseUrl/search/$heroName';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        print('HTTP fel: ${response.statusCode} – ${response.reasonPhrase}');
        return null;
      }
      final heroData = jsonDecode(response.body);
      if (heroData is! Map<String, dynamic>) return null;
      if ((heroData['response'] ?? '') != 'success') return null;

      final results = heroData['results'];
      if (results is List) {
        // Säker cast till List<Map<String, dynamic>>
        return results
            .whereType<Map>() // filtrera bort ev. skräp
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      return null;
    } catch (e) {
      print('Fel vid hämtning av hjälte: $e');
      return null;
    } finally {
      // valfri logging
      // print('Nätverksanrop slutfört.');
    }
  }

  @override
  Future<HeroModel?> fetchHeroModel(String heroName) async {
    try {
      final results = await fetchHero(heroName);
      if (results == null || results.isEmpty) {
        print('Ingen hjälte hittades med namnet: $heroName');
        return null;
      }
      // Ta första träffen och bygg modell
      if (results.length>1) {
        print('${results.length} hjältar hittades. Använder första träffen: ${results.first['name']}');
      } else {
        print('Hjälte hittad: ${results.first['name']}');
      }
      return HeroModel.fromJson(results.first);
    } catch (e) {
      print('Fel vid skapande av HeroModel: $e');
      return null;
    }
  }
}
