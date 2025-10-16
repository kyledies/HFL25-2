//* Abstrakta klasser kan inte instansieras direkt, utan fungerar som mallar för andra klasser
//* Abstrakta metoder måste implementeras i subklasser. Metoder kan vara fördigdefinierade eller abstrakta
abstract class Animal {
  void eat() => print('Eating...'); //färdigdefinierad
  void makeSound(); // abstrakt. 
}
//* @override används för att markera att en metod från superklassen implementeras eller ändras
//* extends används för att ärva från en annan klass - 
class Dog extends Animal { //ärver från Animal, måste implementera makeSound
  @override
  void makeSound() => print('Woof!');
}

class Cat extends Animal { //ärver från Animal, gör override av eat och implementerar makeSound
  @override
  void eat() => print('Not hungry...');
  @override
  void makeSound() => print('Mjau!');
}
  
  void main() {
  var dog = Dog();
  var cat = Cat();
  dog.eat();        // ärvt från Animal
  dog.makeSound();  // Woof!
  cat.eat();        // Not hungry...
  cat.makeSound();  // Mjau!
}

