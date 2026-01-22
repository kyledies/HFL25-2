import 'package:firebase_auth/firebase_auth.dart';

// Detta är datalagret - Här hanteras Firebase Auth.
// Ingen annan del av koden pratar direkt med FirebaseAuth.

/// Denna klass ansvarar för all kommunikation med Firebase Auth.
/// Resten av appen vet inte att Firebase finns, de pratar bara med denna klass.
/// Den exponerar metoder för inloggning, utloggning och skapande av användare,
/// samt en Stream som sänder ut inloggningsstatus i realtid.
class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  /// Konstruktor: Vi tillåter att man skickar in en instans (bra för testning),
  /// annars använder vi standardinstansen av FirebaseAuth.
  /// var res = A ?? B -> A icke null, använd A, annars B.
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Hjälpmetod för att snabbt få tag på nuvarande användare
  /// (returnerar null om ingen är inloggad).
  User? get currentUser => _firebaseAuth.currentUser;

  /// VIKTIGT: Detta är en "Radio-kanal" (Stream).
  /// Firebase sänder ut signaler här varje gång inloggningsstatusen ändras.
  /// (t.ex. vid inloggning, utloggning, eller om sessionen dör).
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Loggar in användaren med email och lösenord.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Försök logga in hos Firebase Auth
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      // Om något går fel (fel lösen, inget nätverk),
      // kasta ett felmeddelande som UI:t kan visa upp.
      throw Exception(e.message);
    }
  }

  /// Skapar en ny användare.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Skapa användare hos Firebase Auth
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Loggar ut användaren.
  /// Detta kommer trigga streamen [authStateChanges] att skicka 'null'.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
