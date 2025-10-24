import 'dart:async';
//import 'dart:io';
import 'package:v04/helpers/input_helper.dart' as input;

/// Skriver ut huvudmenyn med små fördröjningar (visuell polish).
Future<void> printMainMenu() async {
  print('\nAnge val (1–6):');
  await Future.delayed(const Duration(milliseconds: 500));
  print('1. Lägg till hjälte manuellt');
  await Future.delayed(const Duration(milliseconds: 400));
  print('2. Lägg till hjälte via API');
  await Future.delayed(const Duration(milliseconds: 300));
  print('3. Visa alla hjältar');
  await Future.delayed(const Duration(milliseconds: 200));
  print('4. Sök hjälte lokalt');
  await Future.delayed(const Duration(milliseconds: 100));
  print('5. Spara och Avsluta');
  await Future.delayed(const Duration(milliseconds: 100));
  print('6. Rensa ALL Data');
}

/// Läser ett heltalsval 1..6 via din befintliga helper.
int readMainMenuChoice() {
  return input.readInt('Val: ', min: 1, max: 6);
}