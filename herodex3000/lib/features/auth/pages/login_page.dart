import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herodex3000/features/auth/auth_cubit.dart';
import 'package:herodex3000/features/auth/widgets/signup_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Nyckeln behövs för att validera formuläret (kolla att fält inte är tomma)
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (AppBar och layout) ...
    return Scaffold(
      appBar: AppBar(
        // Bakgrund = Din huvudfärg
        backgroundColor: Theme.of(context).colorScheme.primary,

        // Förgrund (Text & Ikoner) = Färgen som passar ovanpå huvudfärgen (oftast vit)
        foregroundColor: Theme.of(context).colorScheme.onPrimary,

        centerTitle: true,
        title: const Text('Login View'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                // style: TextButton.styleFrom(
                //   foregroundColor: Theme.of(context).colorScheme.tertiary,
                // ),
                onPressed: () async {
                  // 1. Kolla om fälten är ifyllda korrekt
                  if (_formKey.currentState!.validate()) {
                    try {
                      // 2. Anropa Cubiten för att logga in.
                      // Vi använder 'read' för funktioner (vill inte lyssna på ändringar här).
                      // 'await' är viktigt för att vi ska kunna fånga fel!
                      await context.read<AuthCubit>().signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                      // Om inloggningen lyckas behöver vi inte göra något.
                      // Vid lyckad inloggning uppdateras AuthCubit.
                      // GoRouter redirect hanterar sedan navigationen automatiskt.
                    } catch (e) {
                      /// 3. Om det misslyckas: Visa felet för användaren.
                      if (!context.mounted) return; // Säkerhetskoll

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fel vid inloggning: $e'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              // Knappen för att öppna popupen
              TextButton(
                onPressed: () {
                  // HÄR använder vi showDialog
                  showDialog(
                    context: context,
                    // barrierDismissible: false, // Vill du tvinga användaren att klicka Avbryt?
                    builder: (context) => const SignUpDialog(),
                  );
                },
                child: const Text('Har du inget konto? Skapa ett här'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
