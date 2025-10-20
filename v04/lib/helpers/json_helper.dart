typedef JsonMap = Map<String, dynamic>; //skapar alias för Map<String, dynamic>

// Konverterar ett dynamiskt värde till en int, om möjligt.
int? toInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
// Konverterar ett dynamiskt värde till en String, om möjligt.
String? toStr(dynamic value) {
  if (value is String) return value;
  return null;
}
// Konverterar lista med dynamiska värden till en lista av strängar, om möjligt.
List<String>? toStrList(dynamic value) {
  //nedan - map går igenom varje element i listan och konverterar till sträng: value.map((e) => e.toString())
  if (value is List) return value.map((e) => e.toString()).toList();
  return null;
}

// Konverterar ett dynamiskt värde till en JSON-mapp, om möjligt.

JsonMap? toJsonMap(dynamic value) => (value is Map<String, dynamic>) ? value : null;
// villkor ? om_sant : om_falskt. Villkor: är value en Map<String, dynamic> OM ja => returnera value (Map<String, dynamic>), annars returnera null

//Ovan. => är samma som:
 /*Json? toJsonMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  } else {
    return null;
  }
}
 */
