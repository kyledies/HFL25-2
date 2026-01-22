import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herodex3000/features/auth/auth_state.dart';
import 'package:herodex3000/features/auth/auth_repository.dart';

//Cubit är en klass som håller reda på ett state (AuthState).
// Den exponerar funktioner (signIn, signOut och signUp) som UI:t kan anropa.
//När något händer använder den kommandot emit(NyttState) för att säga åt UI:t att rita om sig.
 
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  // Vi måste spara streamen så vi kan avsluta den när appen dör.
  late final StreamSubscription<User?> _authStateSubscription;
 
 
  /// Konstruktor: Startar med [AuthInitial].
  /// Startar direkt en lyssnare på repositoryts ström.
  AuthCubit(this._authRepository) : super(AuthInitial()) {
    // HÄR sker magin! Vi lyssnar på Firebase i realtid. Vid ändring körs kod nedan
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        // Om user finns -> Skicka ut Authenticated-state med användaren
        emit(AuthAuthenticated(user));
      } else {
        // Om user är null -> Skicka ut Unauthenticated-state
        emit(AuthUnauthenticated());
      }
    });
  }
  /// UI:t (login_screen) ropar på denna. Vi skickar bara vidare ordern till "Köket" (Repot).
  /// Cubiten uppdaterar INTE statet här manuellt. Den väntar på att 
  /// _authStateSubscription (ovan) ska reagera på att inloggningen lyckades.
  Future<void> signIn(String email, String password) async {
  emit(AuthInitial()); // visar splash
  try {
    await _authRepository.signIn(email: email, password: password);
    // Vid lyckad login kommer authStateChanges -> AuthAuthenticated automatiskt
  } catch (e) {
    emit(AuthUnauthenticated()); // ✅ lämna splash vid fel
    rethrow; // så UI kan visa SnackBar med fel
  }
}
 
  Future<void> signOut() async {
  emit(AuthInitial()); // visar splash
  try {
    await _authRepository.signOut();
    //  authStateChanges -> AuthUnauthenticated kommer
  } catch (e) {
    // valfritt men bra: om signOut skulle faila, gå tillbaka till "inloggad" om du vill
    // annars kan du bara rethrow
    rethrow;
  }
}

  Future<void> signUp(String email, String password) async {
  emit(AuthInitial()); // visar splash
  try {
    await _authRepository.signUp(email: email, password: password);
    // Vid lyckad signup blir du ofta auto-inloggad -> seen in stream
  } catch (e) {
    emit(AuthUnauthenticated()); // lämna splash vid fel
    rethrow;
  }
}

  /// Städar upp när Cubiten stängs ner (för att undvika minnesläckor).
  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}