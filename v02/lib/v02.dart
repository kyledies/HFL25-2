import 'dart:io';

// =====Hjälpfunktioner för inmatning och validering====

//Funktion för att läsa in Sträng och hantera null eller tom sträng
String readString(String prompt) {
  while(true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
    print('Ogiltig inmatning. Försök igen.');
  }
}

  //Funktion för att läsa in Str, konvertera till Int och hantera null eller tom sträng
  int readInt(String prompt) {
    while(true) {
      stdout.write(prompt);
      final input = stdin.readLineSync();
      if (input != null && input.trim().isNotEmpty) {
        final intValue = int.tryParse(input.trim());
        if (intValue != null) {
          return intValue;
        }
        print("Ogiltig inmatning. Ange ett heltal.");
      }
    }
  }

// =====Huvudfunktioner för att arbeta på listan heroes ====
void addHero(List<Map<String, dynamic>> heroes) {
  // * Implementation av att lägga till hjälte - checkar null, tom sträng och icke-heltal
  print("\n --- Läggg till hjälte---");
  final name = readString('Ange namn: ');
  final gender = readString('Ange kön: ');
  final race = readString('Ange typ: ');
  final strength = readInt('Ange Strength: ');
  final defence = readInt('Ange Defence: ');
  final health = readInt('Ange Health: ');
  final alignment = readString('Ange Ond/God: ');
  final residence = readString('Ange boplats: ');
  final weakness = readString('Ange Svaghet: ');
  
  final hero = <String, dynamic>{
    'name': name,
    'appearance': {
      'gender': gender,
      'race:': race,
    },
    'powerstats': {
      'strength': strength,
      'defence': defence,
      'health': health,
    },
    'biography': {
      'alignment': alignment,
      'residence': residence,
      'weakness': weakness,
    },
    'createdAt': DateTime.now().toIso8601String(),
  };

  heroes.add(hero);
  print("Hjälte: $name tillagd. Antal hjältar i listan: ${heroes.length}\n");
  
}
//   'final choice = stdin.readLineSync(); // final OK då det sätts varje gång i loopen
//     if (choice == null || choice.trim().isEmpty) {  //Hantera null eller tom inmatning
//       print('Ogiltigt val (tom sträng/null).');
//       continue; // Går tillbaka till början av loopen
//     }
  
  
  
//   final hero = <String, dynamic>{
//     'name': name,
//     'power': power,
//     'level': level,
//     'createdAt': DateTime.now().toIso8601String(),
//   };

//   heroes.add(hero);
//   print('✅ Hjälte tillagd: $name (level $level). Antal hjältar: ${heroes.length}\n');
// }
// }'

void showHeroes(List<Map<String, dynamic>> heroes) {
  // Implementation for showing all heroes
}

void searchHero(List<Map<String, dynamic>> heroes) {
  // Implementation for searching a hero
}
