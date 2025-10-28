import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:v04/models/hero_model.dart';

// Definierar kontraktet för NetworkManager - vilka metoder den måste implementera
abstract class NetworkServiceManaging {
  Future<List<Map<String, dynamic>>?> fetchHero(String heroName);
  Future<List<HeroModel>?> fetchHeroModel(String heroName); //Lista med HeroModel -> Tom lista om ingen hittas
}

//------------------------------------------------------------------------------//

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
    final url = '$baseUrl/search/${Uri.encodeComponent(heroName)}';
    try {
      final response = await http.get(Uri.parse(url));
      //response.body har nu json-datat vi kommer bearbeta
      if (response.statusCode != 200) {
        print('HTTP fel: ${response.statusCode} (Råkade du ange Å/Ä/Ö?)');
        return null;
      }
      // Får nedan ut map med key:vals 1 - response , 2 - results-for, 3 - lista med {herodata}
      final heroData = jsonDecode(response.body); 
      //Om svar ej är Map - bryt
      if (heroData is! Map<String, dynamic>) {
        print('Oväntat svarsformat från API - Försök igen');
        return null;
      }
      //saknas fält response, eller response != success
      if ((heroData['response'] ?? '') != 'success') {
        //print('Ingen träff för din sökterm ${heroName}');
        return null;
      }

      final results = heroData['results'];
      if (results is List) {
        // results är nu en list med map - varje map har 8 element (id, name, powerstats...)
        //nedan filtreras icke-map bort samt typear vi varje map till Map<String, dynamic> och
        //lägger i lista.
        return results
            .whereType<Map>() // filtrera icke-map
            .map((e) => Map<String, dynamic>.from(e as Map)) 
            .toList();
      }
      return null;
    } catch (e) {
      print('Fel vid hämtning av hjälte: $e');
      return null;
    } finally {
      // print('Nätverksanrop slutfört.');
    }
  }

  @override
  Future<List<HeroModel>> fetchHeroModel(String heroName) async {
    try {
      final results = await fetchHero(heroName); //inväntar svar från fetchHero, som är en lista med mappar
      if (results == null || results.isEmpty) {
        return <HeroModel>[]; // Returnerar tom lista om ingen hjälte hittades
      }
      //res.map... -> gör om varje element till något nytt
      // I listan results har vi flera element (varje element = decodad json -> map<String, dynamic>)
      //results.map((json) => Hero... .tolist()) -> För varje element, skapa heroobjekt och lägg i lista.
      return results.map((decodedList) => HeroModel.fromJson(decodedList)).toList();
    } catch (e) {
      print('Fel vid skapande av HeroModel lista: $e');
      return <HeroModel>[];
    }
  }
}