import 'package:v04/models/hero_model.dart';
import 'dart:convert';
import 'dart:io';

abstract class HeroFileStorage {
  /// Laddar alla hjältar från lagring.
  /// Tom lista om filen saknas eller är tom/ogiltig.
  Future<List<HeroModel>> loadAll();

  /// Sparar alla hjältar till lagring (skriver över befintligt innehåll).
  Future<void> saveAll(List<HeroModel> heroes);

/// Tömmer lagring
  Future<void> clearAll();
}
//------------------------------------------------------------------------------//

// lib/storage/file_storage_manager.dart


/// Minimal JSON-filbaserad lagring.
/// Sparar en lista av hjältar som JSON-array i [path] 
/// Standardfil för lagring = data/heroes.json
class FileStorageManager implements HeroFileStorage {
  
  final String path; //sökväg till fil där data sparas

  FileStorageManager({this.path = 'data/heroes.json'});

///Säkerställer att dir för fil finns innan läsning/skrivning till fil
  Future<void> _ensureDir() async {
    final dir = Directory(path).parent;
    //Skapar dir om det saknas 
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  @override
  //Laddar in json-data och konverterar till lista med hero-objekt
  Future<List<HeroModel>> loadAll() async {
    try {
      final file = File(path);
      //Finns inte filen - returnera tom lista
      if (!await file.exists()) return <HeroModel>[];

      //läs in fil som sträng - returnera tom lista om filen är tom
      final content = await file.readAsString();
      if (content.trim().isEmpty) return <HeroModel>[];

      //Försök med Json-dekodning av innehåll - ska bli lista med Map<String, dynamic) i praktiken - annars returnera tom lista
      final decoded = jsonDecode(content);
      if (decoded is! List) return <HeroModel>[];


      return decoded
          .whereType<Map>() //I lista decoded - Där värden är Map<String, Dynamic> skapar vi hero-objekt och lägger i lista
          .map((m) => HeroModel.fromJson(Map<String, dynamic>.from(m as Map)))
          .toList();
    } catch (_) {
      // Vid fel: returnera tom lista (håll appen vid liv)
      return <HeroModel>[];
    }
  }

  //Konverterar lista med Hero-objekt till json-format och sparar ned.
  @override
  Future<void> saveAll(List<HeroModel> heroes) async {
    await _ensureDir();
    final file = File(path);
    final list = heroes.map((h) => h.toJson()).toList();
    final pretty = const JsonEncoder.withIndent('  ').convert(list);
    await file.writeAsString(pretty, flush: true);
  }

//Rensar data
@override
  Future<void> clearAll() async {
    await _ensureDir();
    final file = File(path);
    await file.writeAsString('[]\n', flush: true);
  }
}

