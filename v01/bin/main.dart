import 'dart:io';
import 'package:v01/v01.dart' as v01;
void main() {

  print('Ange första talet:');
  String? tal1 = stdin.readLineSync();
  int numerictal1 = int.parse(tal1!);
  
  print('Ange andra talet:');
  String? tal2 = stdin.readLineSync();
<<<<<<< Updated upstream
<<<<<<< Updated upstream
  int numerictal2 = int.parse(tal2!);
=======
  int numerictal2 = int.parse(tal2!);  
>>>>>>> Stashed changes
=======
  int numerictal2 = int.parse(tal2!);  
>>>>>>> Stashed changes
  
  print('Du valde $numerictal1 och $numerictal2');
  print('Ange operation: +,-,*,/,**:');
  String? operation = stdin.readLineSync();
  if (operation == '+') {
    print('$numerictal1 + $numerictal2 = ${v01.addition(numerictal1, numerictal2)}');
  } else if (operation == '-') {
    print('$numerictal1 - $numerictal2 = ${v01.subtraction(numerictal1, numerictal2)}');
  } else if (operation == '*') {
    print('$numerictal1 * $numerictal2 = ${v01.multiplication(numerictal1, numerictal2)}');
  } else if (operation == '/') {
    print('$numerictal1 / $numerictal2 = ${v01.division(numerictal1, numerictal2)}');
  } else if (operation == '**') {
    print('$numerictal1 upphoejt med $numerictal2 = ${v01.powerby(numerictal1, numerictal2)}');
  } else {
    print('Ogiltig operation');
  }

}
