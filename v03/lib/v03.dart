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
        if (intValue != null && intValue >= 0 && intValue <= 100) {
          return intValue;
        }
        print("Ogiltig inmatning. Ange ett heltal mellan 0-100.");
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
  final strength = readInt('Ange Strength (0-100): ');
  final defence = readInt('Ange Defence (0-100): ');
  final health = readInt('Ange Health (0-100): ');
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

void showHeroes(List<Map<String, dynamic>> heroes) {
  // Visar alla hjältar i listan sorterat på strength
  print("\n--- Alla Hjältar ---");
  if (heroes.isEmpty) {
    print("Inga hjältar i listan.\n");
    return;
  }
  final List<Map<String, dynamic>> sortedHeroes = List<Map<String, dynamic>>.from(heroes); // Skapar en kopia av listan för sortering
  // Använder sort-metoden med en jämförelsefunktion. 
  //*Förstår inte helt...Tar två element a och b - Jämför deras strength. Kika på compareTo i Dart docs..
  //* Om bStrength är större än aStrength → compareTo blir positivt → a efter b
  //* Om aStrength är större än bStrength → compareTo blir negativt → a före b 
  sortedHeroes.sort((a, b) {
    final aStrength = (a['powerstats'] as Map<String, dynamic>) ['strength'] as int;
    final bStrength = (b['powerstats'] as Map<String, dynamic>) ['strength'] as int;
    return bStrength.compareTo(aStrength); // DESC
});

  // Sortera hjältar på strength (fallande), mer lättläst med for in...
    sortedHeroes.forEach((hero) {
      final name = hero['name'];
      final strength = (hero['powerstats'] as Map<String, dynamic>)['strength'];
      print('Namn: $name, Strength: $strength');
  });
  //printar sorterad lista mha for each   
}

void searchHero(List<Map<String, dynamic>> heroes) {
  // Söker efter matchande hjälte i listan
  print("\n--- Sök Hjälte ---");
  stdout.write('Ange namn att söka efter: ');
  final input = stdin.readLineSync();
  final query = (input ?? '').trim().toLowerCase(); // Om searchHero är null, sätt query till tom sträng
  if (query.isEmpty) {
    print("Tom söksträng.\n");
    return;
  }
  //where-metod nedan filtrerar listan baserat på villkor inom {}
  final results = heroes.where((hero) {
    final name = (hero['name'] as String).toLowerCase();
    return name.contains(query); // Kollar om namn innehåller söksträngen
  }).toList();

/** 
 * OBS nedan - likvärdigt med heroes.where ovan
final List<Map<String, dynamic>> results = [];
for (final hero in heroes) {
  final name = (hero['name'] as String).toLowerCase();
  if (name.contains(query)) {
    results.add(hero);
  }
}
*/
  if (results.isEmpty) {
    print("Inga matchande hjältar för '$query'.\n");
  } else {
    print("Hittade ${results.length} matchande hjältar:");
    results.forEach((hero) {
      final name = hero['name'];
      final strength = (hero['powerstats'] as Map<String, dynamic>)['strength'];
      print('Namn: $name, Strength: $strength');
    });
    print('');
  }
}