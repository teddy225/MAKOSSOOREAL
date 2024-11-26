import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';

// Page principale avec la logique de bascule entre login et inscription
class AuthenticationScreen extends ConsumerStatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();

  bool isLoginView = true; // Contrôle la vue active, Login ou Inscription

  // Méthode pour gérer l'inscription ou la connexion
  Future<void> _handleSubmit() async {
    if (isLoginView) {
      // Connexion
      ref.read(authStateProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
    } else {
      // Inscription
      final data = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'country': _countryController.text,
        'password': _passwordController.text,
      };
      ref.read(authStateProvider.notifier).register(data);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isLoginView ? 'Connexion' : 'Inscription')),
      body: authState.when(
        data: (user) {
          if (user != null) {
            // Si l'utilisateur est connecté, rediriger vers la page d'accueil
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacementNamed(context, 'Home');
            });
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isLoginView)
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Nom et Prénoms'),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                ),
                if (!isLoginView)
                  TextField(
                    controller: _phoneController,
                    decoration:
                        InputDecoration(labelText: 'Numéro de téléphone'),
                  ),
                if (!isLoginView)
                  TextField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: 'Pays'),
                  ),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text(isLoginView ? 'Se connecter' : 'S\'inscrire'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginView = !isLoginView; // Basculer la vue
                    });
                  },
                  child: Text(isLoginView
                      ? 'Pas encore de compte ? S\'inscrire'
                      : 'Déjà un compte ? Se connecter'),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
    );
  }
}
