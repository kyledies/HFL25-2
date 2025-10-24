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
/// Sparar en lista av hjältar som JSON-array i [path] (default: data/heroes.json).
class FileStorageManager implements HeroFileStorage {
  final String path;

  FileStorageManager({this.path = 'data/heroes.json'});

  Future<void> _ensureDir() async {
    final dir = Directory(path).parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  @override
  Future<List<HeroModel>> loadAll() async {
    try {
      final file = File(path);
      if (!await file.exists()) return <HeroModel>[];

      final content = await file.readAsString();
      if (content.trim().isEmpty) return <HeroModel>[];

      final decoded = jsonDecode(content);
      if (decoded is! List) return <HeroModel>[];

      return decoded
          .whereType<Map>() // säkra
          .map((m) => HeroModel.fromJson(Map<String, dynamic>.from(m as Map)))
          .toList();
    } catch (_) {
      // Vid fel: returnera tom lista (håll appen vid liv)
      return <HeroModel>[];
    }
  }

  @override
  Future<void> saveAll(List<HeroModel> heroes) async {
    await _ensureDir();
    final file = File(path);
    final list = heroes.map((h) => h.toJson()).toList();
    final pretty = const JsonEncoder.withIndent('  ').convert(list);
    await file.writeAsString(pretty, flush: true);
  }

@override
  Future<void> clearAll() async {
    await _ensureDir();
    final file = File(path);
    await file.writeAsString('[]\n', flush: true);
  }
}

