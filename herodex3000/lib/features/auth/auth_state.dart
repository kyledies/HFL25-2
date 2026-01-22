import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
 
//Här definieras vilka lägen appen kan finnas i - emittas av AuthRepository via Cubit/Bloc.

/// Bas-klassen för alla auth-tillstånd - AuthInitial, AuthAuthenticated, AuthUnauthenticated.
/// Vi använder Equatable för att Flutter ska förstå att två likadana states
/// är samma sak (så vi slipper rita om skärmen i onödan).
abstract class AuthState extends Equatable {
  const AuthState();
 
  @override
  List<Object?> get props => [];
}
 
/// Startläget: Appen har precis startat och vi har inte hunnit kolla
/// med Firebase om användaren är inloggad än (oftast visas en splash-screen här).
class AuthInitial extends AuthState {}
 
/// Inloggad: Vi vet att användaren är godkänd.
/// VIKTIGT: Vi skickar med själva [User]-objektet här, så att UI:t
/// kan komma åt e-post, namn och ID utan att behöva fråga repot igen.
class AuthAuthenticated extends AuthState {
  final User user;
 
  const AuthAuthenticated(this.user);
 
  /// Vi måste ta med 'user' i props. Om användaren ändras, är det ett nytt state.
  @override
  List<Object?> get props => [user];
}
/// Utloggad: Vi vet säkert att ingen är inloggad. Visa login-skärmen.
class AuthUnauthenticated extends AuthState {}