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

/// Skriver ut prompt och alternativ i lista - MÅSTE välja därifrån
readOptions(String prompt, List<String> options) {
  final hint = '[${options.join(', ')}]'; //joinar alt för print
  while (true) {
    stdout.write('$prompt: $hint');
    final input = stdin.readLineSync();
    final value = input?.trim().toLowerCase();

    if (options.contains(value)) {
      return value;
    }
    print('Ogiltigt val: Ange ett av: $hint');
  }
}


/// Läser ett heltal där detta är required. Valbart intervall [min, max].
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

/// Läser ett heltal där detta är optional
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