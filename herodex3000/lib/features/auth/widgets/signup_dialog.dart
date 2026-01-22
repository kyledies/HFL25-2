import 'dart:ui'; // Behövs för ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herodex3000/core/services/consent_analytics.dart';
import 'package:herodex3000/features/auth/auth_cubit.dart';
import 'package:herodex3000/features/auth/auth_repository.dart'; // Justera imports

/// En separat widget för "Skapa konto"-rutan.
/// Vi lägger den i en egen fil för att inte stöka ner login_screen.dart.
class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  State<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  // GlobalKey används för att "låsa upp" formuläret så vi kan kolla om det är giltigt.
  final _formKey = GlobalKey<FormState>();
  
  // Controllers fungerar som "öron" på textfälten – de lyssnar och sparar vad som skrivs.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // En variabel för att visa felmeddelanden direkt i rutan (t.ex. "Mailen upptagen").
  // Om den är null visas ingen text.
  String? _errorMessage;

  //bool för att visa laddningsindikator "i väntan på firebase"
  bool _isLoading = false;

  @override
  void dispose() {
    // VIKTIGT: Städa alltid upp controllers när fönstret stängs för att spara minne.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BackdropFilter lägger ett filter över allt som ligger BAKOM denna widget.
    // Här använder vi det för att göra LoginScreen suddig (Blur).
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Styr hur mycket blur det blir
      child: AlertDialog(
        title: const Text('Skapa konto'),
        
        // Innehållet i rutan
        content: Form(
          key: _formKey, // Kopplar formuläret till vår nyckel
          child: Column(
            mainAxisSize: MainAxisSize.min, // Gör kolumnen så liten som möjligt (annars tar den hela höjden)
            children: [
              
              // --- EMAIL ---
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                // Validatorn körs när vi kallar på _formKey.currentState!.validate()
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ange en email';
                  }
                  // Regex: Kollar att det ser ut som en mail (text + @ + text + . + text)
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                  if (!emailValid) {
                    return 'Ogiltigt format';
                  }
                  return null; // Null betyder "Inget fel, godkänt!"
                },
              ),
              
              // --- LÖSENORD ---
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Lösenord'),
                obscureText: true, // Döljer texten (stjärnor)
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Minst 6 tecken krävs';
                  }
                  return null;
                },
              ),

              // --- FELMEDDELANDE (Visa bara om det finns ett fel) ---
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        
        // Knapparna längst ner i rutan
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Stänger bara rutan
            child: const Text('Avbryt'),
          ),
          ElevatedButton(
            onPressed: () async {
              // 1. Kör alla validators i formuläret
              if (_formKey.currentState!.validate()) {
                
                // Nollställ gamla fel så texten försvinner vid nytt försök
                setState(() {
                  _errorMessage = null;
                });

                final authCubit = context.read<AuthCubit>();
                final authRepo = context.read<AuthRepository>();
                final consentAnalytics = context.read<ConsentAnalytics>();
                try { //1 Skapa konto (firebase auth)
                  await authCubit.signUp(
                        _emailController.text,
                        _passwordController.text,
                    );
                    //2 Logga signup om det lyckas 
                    final uid = authRepo.currentUser?.uid;
                    if (uid != null) {
                      await consentAnalytics.logSignUp(uid);
                    }
                  // 3. Om vi kommer hit gick allt bra! (Ingen 'catch' kördes).
                  // Kolla 'mounted' för att vara säker på att rutan fortfarande finns på skärmen.
                  if (!context.mounted) return;
                  
                  Navigator.of(context).pop(); // Stäng rutan
                    
                    // Visa en bekräftelse på bakgrundsskärmen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Konto skapat!Loggas in...')),
                    );
                } catch (e) {
                  // 4. Om Firebase kastar ett fel (t.ex. "Mailen upptagen") hamnar vi här.
                  if (!context.mounted) return; 
                    setState(() {
                      // Uppdatera variabeln -> Flutter ritar om -> Röd text visas
                      // .replaceAll städar bort ordet "Exception:" så det ser snyggare ut.
                      _errorMessage = e.toString().replaceAll("Exception: ", "");
                    });
                  
                }
              }
            },
            child: const Text('Skapa'),
          ),
        ],
      ),
    );
  }
}