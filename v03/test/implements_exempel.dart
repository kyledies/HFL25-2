// Exempel på implements nedan
// * implements används för att implementera ett interface 
// * Vid implements ärvs ingen kod, utan alla metoder måste definieras i den nya klassen OAVSETT om de är färdigdefinierade i bas-typen
abstract class Animal {
  void eat() => print('Eating...'); // färdigdefinierad i bas-typen
  void makeSound() => print("Animal eating sound...");  
  int get numberOfLegs; // abstrakt getter               
}

class Dog implements Animal {
  @override
  void eat() => print('Dog eating...'); // MÅSTE definieras (inget arv av kod)

  @override
  void makeSound() => print('Woof!');

  @override
  int get numberOfLegs => 4;
}

class Cat implements Animal {
  @override
  void eat() => print('Not hungry...'); // MÅSTE definieras

  @override
  void makeSound() => print('Mjau!');

  @override
  int get numberOfLegs => 4;
}
  
  void main() {
  var dog = Dog();
  var cat = Cat();
  dog.eat();        // Dog eating...
  dog.makeSound();  // Woof!
  print("Dog has ${dog.numberOfLegs} legs.");
  cat.eat();        // Not hungry...
  cat.makeSound();  // Mjau!
  print("Cat has ${cat.numberOfLegs} legs.");
}

