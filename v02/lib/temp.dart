//* Slaskfil för att testa kodbitar
//? Final variable - kan inte ändras efter initiering
//? Const variable - compile-time constant, måste initieras vid deklaration

void main() {
  List<Map<String, dynamic>> heroes = [];
  final hero = <String, dynamic>{
    'name': "Superman",
    'appearance': {
      'gender': "Man",
      'race:': "Human",
    },
    'powerstats': {
      'strength': 100,
      'defence': 70,
      'health': 120,
    },
    'biography': {
      'alignment': "Good",
      'residence': "City",
      'weakness': "Cryptonite",
    },
    'createdAt': DateTime.now().toIso8601String(),
  };

  heroes.add(hero);
  print(heroes);
  print(heroes[0]['powerstats']['strength']); // 100

}