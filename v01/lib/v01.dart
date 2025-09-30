//Logik ligger här (funktioner, klasser etc)
import 'dart:math';

num addition(num a, num b) {
  //returnerar summan av a och b
  return a + b;
}

num subtraction(num a, num b) {
  //returnerar subtraktionen av a och b
  return a - b;
}

num multiplication(num a, num b) {
  //returnerar multiplikationen av a och b
  return a * b;
}

num division(num a, num b) {
  //returnerar divisionen av a och b
  if (b == 0) {
    throw ArgumentError('Division by zero is not allowed.');
  }
  return a / b;
}

num powerby(num base, num exponent) {
  //returnerar basen upphöjt till exponenten
  return pow(base, exponent);
}
