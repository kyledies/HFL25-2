import '../helpers/json_helper.dart';

class Powerstats{ //väljer String för att matcha API?
  final int? intelligence;
  final int? strength;
  final int? speed;
  final int? durability;
  final int? power;
  final int? combat;

  const Powerstats({
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  });

  /// Medelvärde av befintliga stats (0–100), eller null om inga finns
  double? get avg {
    final vals = [
      intelligence, strength, speed, durability, power, combat
    ].whereType<int>(); // filtrerar bort null
    if (vals.isEmpty) return null;
    final sum = vals.reduce((a, b) => a + b);
    return sum / vals.length;
  }

  // typedef Json = Map<String, dynamic>; //skapar alias för Map<String, dynamic>
  // Factory konstruktor som skapar Powerstats objekt från JSON data (Map<String, dynamic>)
  factory Powerstats.fromJson(JsonMap json) => Powerstats(
    intelligence: toInt(json['intelligence']),
    strength:     toInt(json['strength']),
    speed:        toInt(json['speed']),
    durability:   toInt(json['durability']),
    power:        toInt(json['power']),
    combat:       toInt(json['combat']),
  );

  JsonMap toJson() => {
    'intelligence': intelligence,
    'strength': strength,
    'speed': speed,
    'durability': durability,
    'power': power,
    'combat': combat,
  };
}
