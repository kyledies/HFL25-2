import 'dart:io';

// =====Hjälpfunktioner för inmatning och validering====

/// Läser en icke-tom sträng (trimmad).
String readString(String prompt) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    if (input != null && input.trim().isNotEmpty) {
      return input.trim();
    }
    print('Ogiltig inmatning. Försök igen.');
  }
}

/// Läser ett heltal. Valbart intervall [min, max].
/// Om min/max är null begränsas inte den sidan.
int readInt(String prompt, {int? min, int? max}) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    if (input == null || input.trim().isEmpty) {
      print('Ogiltig inmatning. Ange ett heltal.');
      continue;
    }
    final value = int.tryParse(input.trim());
    if (value == null) {
      print('Ogiltig inmatning. Ange ett heltal.');
      continue;
    }
    if (min != null && value < min) {
      print('Ogiltig inmatning. Värdet måste vara ≥ $min.');
      continue;
    }
    if (max != null && value > max) {
      print('Ogiltig inmatning. Värdet måste vara ≤ $max.');
      continue;
    }
    return value;
  }
}

/// Läser ett heltal eller tomt värde (returnerar null om användaren bara trycker Enter).
/// Valbart intervall [min, max] om användaren anger ett tal.
int? readOptionalInt(String prompt, {int? min, int? max}) {
  while (true) {
    stdout.write(prompt);
    final input = stdin.readLineSync();
    if (input == null) return null; // extremfall
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null; // tomt = null

    final value = int.tryParse(trimmed);
    if (value == null) {
      print('Ogiltig inmatning. Ange ett heltal eller lämna tomt.');
      continue;
    }
    if (min != null && value < min) {
      print('Ogiltig inmatning. Värdet måste vara ≥ $min.');
      continue;
    }
    if (max != null && value > max) {
      print('Ogiltig inmatning. Värdet måste vara ≤ $max.');
      continue;
    }
    return value;
  }
}

/// Läser ett menyval (t.ex. 1–4).
int readMenuChoice(String prompt, {required int min, required int max}) {
  return readInt(prompt, min: min, max: max);
}