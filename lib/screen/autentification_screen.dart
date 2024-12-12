import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';

// Page principale avec la logique de bascule entre login et inscription
class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  AuthenticationScreenState createState() => AuthenticationScreenState();
}

class AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final List<String> countries = [
    'France',
    'Canada',
    'États-Unis',
    'Allemagne',
    'Brésil',
    'Japon',
    'Chine',
    'Royaume-Uni',
    'Italie',
    'Espagne'
  ];

  final _formKey = GlobalKey<FormState>();
  var emailUser = '';
  var passwordUser = '';
  var username = '';
  var phoneUser = '';
  var countryUser = '';
  bool ischarge = false;

  Future<void> submit() async {
    final validerForm = _formKey.currentState!.validate();

    if (validerForm) {
      _formKey.currentState!.save();

      try {
        if (isLoginView) {
          await ref.read(authStateProvider.notifier).login(
                emailUser,
                passwordUser,
              );
        } else {
          final data = {
            'username': username,
            'email': emailUser,
            'phone': phoneUser,
            'country': countryUser,
            'password': passwordUser,
          };
          final success = await ref.read(authStateProvider.notifier).register(
                data,
              );
          if (success) {
            // Navigate to login page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inscription réussie!')),
            );
            print('login');
            //  Navigator.pushNamed(context, '/login');
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inscription échouée!')),
            );
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  bool isLoginView = true; // Contrôle la vue active, Login ou Inscription
  String screen = 'intro';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    String? selectedCountry;

    return Scaffold(
      body: SingleChildScrollView(
        child: authState.when(
          data: (user) {
            if (user != null) {
              Future.microtask(() {
                Navigator.pushReplacementNamed(context, 'authScreen');
              });
            }
            return Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% de la largeur

              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (isLoginView)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenue',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    if (!isLoginView)
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: screenHeight * 0.012), // 1.5% de la hauteur

                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nom et Prénoms',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 40, 134, 43),
                              ),
                            ),
                          ),
                          validator: (valeur) {
                            if (valeur == null ||
                                valeur.trim().isEmpty ||
                                valeur.length >= 50) {
                              return 'Vérrifier le champ nom et prenom';
                            }
                            return null;
                          },
                          onSaved: (valeur) {
                            if (valeur != null && valeur.isNotEmpty) {
                              username = valeur.trim();
                            }
                          },
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: screenHeight * 0.012), // 1.5% de la hauteur
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 40, 134, 43)),
                          ),
                        ),
                        validator: (valeur) {
                          if (valeur == null ||
                              valeur.trim().isEmpty ||
                              valeur.length >= 50) {
                            return 'Votre email est incorrecte !';
                          }
                          return null;
                        },
                        onSaved: (valeur) {
                          if (valeur != null && valeur.isNotEmpty) {
                            emailUser = valeur.trim();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: screenHeight * 0.012), // 1.5% de la hauteur
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 40, 134, 43)),
                          ),
                        ),
                        validator: (valeur) {
                          if (valeur == null ||
                              valeur.trim().isEmpty ||
                              valeur.length >= 50) {
                            return 'Entrer votre mot de passe SVP!';
                          }
                          return null;
                        },
                        onSaved: (valeur) {
                          if (valeur != null && valeur.isNotEmpty) {
                            passwordUser = valeur.trim();
                          }
                        },
                      ),
                    ),
                    if (!isLoginView)
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: screenHeight * 0.012), // 1.5% de la hauteur
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Numéro de téléphone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 40, 134, 43)),
                            ),
                          ),
                          validator: (valeur) {
                            if (valeur == null ||
                                valeur.trim().isEmpty ||
                                valeur.length >= 50) {
                              return 'Verifier votre numero de Telephone SVP';
                            }
                            return null;
                          },
                          onSaved: (valeur) {
                            if (valeur != null && valeur.isNotEmpty) {
                              phoneUser = valeur.trim();
                            }
                          },
                        ),
                      ),
                    if (!isLoginView)
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: screenHeight * 0.02), // 1.8% de la hauteur
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Pays',
                            labelStyle: TextStyle(
                                fontSize: 18, color: Colors.grey[800]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 40, 134, 43)),
                            ),
                          ),
                          value: selectedCountry,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Colors.grey[800]),
                          items: countries
                              .map((country) => DropdownMenuItem<String>(
                                    value: country,
                                    child: Text(country),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            countryUser = value!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez sélectionner un pays.';
                            }
                            return null;
                          },
                        ),
                      ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2,
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          elevation: 5.0,
                        ),
                        onPressed: submit,
                        child: Text(
                          isLoginView ? 'Se connecter' : 'S\'inscrire',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 30, 134, 33)),
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
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => SizedBox(
            height: screenHeight,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      Icons.close,
                      size: 50,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Une erreur s'est  produite ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    " Veillez verifier votre connection internet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.only(
                          left: 40,
                          right: 40,
                          top: 10,
                          bottom: 10,
                        )),
                    onPressed: () {
                      ref.invalidate(authStateProvider);
                    },
                    child: Text('Réessayer'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
