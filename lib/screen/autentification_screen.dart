import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';

// Page principale avec la logique de bascule entre login et inscription
class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  AuthenticationScreenState createState() => AuthenticationScreenState();
}

class AuthenticationScreenState extends ConsumerState<AuthenticationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    // Créez l'animation controller pour contrôler l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Durée de l'animation
    );

    // Créez l'animation de défilement vertical (montée)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 2), // Départ en bas
      end: Offset(0, 0), // Fin à la position d'origine
    ).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut), // Courbe pour l'animation
    );

    // Démarre l'animation dès que l'écran est affiché
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
  bool error = false;

  Future<void> submit() async {
    final validerForm = _formKey.currentState!.validate();

    if (validerForm) {
      _formKey.currentState!.save();

      try {
        setState(() {
          ischarge = true; // Affiche le loader pendant l'envoi
        });

        final authNotifier = ref.read(authStateProvider.notifier);

        if (isLoginView) {
          await authNotifier.login(
            emailUser,
            passwordUser,
          );
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, 'Home');
        } else {
          final data = {
            'username': username,
            'email': emailUser,
            'phone': phoneUser,
            'country': countryUser,
            'password': passwordUser,
          };
          final success = await authNotifier.register(data);

          if (success) {
            // Inscription réussie
            if (!mounted) return;
            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.success,
              body: Center(
                child: Text(
                  'Inscription valider',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              btnOkOnPress: () {},
            ).show();
            isLoginView = true;
          } else {
            // Erreur lors de l'inscription
            if (!mounted) return;
            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.rightSlide,
              title: 'mauvaise information saisie',
              desc: "L'inscription a échoué",
              btnCancelOnPress: () {
                ref.invalidate(authStateProvider);
              },
              btnOkOnPress: () {
                ref.invalidate(authStateProvider);
              },
            ).show();
          }
        }
      } catch (e) {
        // Gestion des erreurs
        print(e);
        if (!mounted) return;
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Aucun Compte n'a été trouvé ",
          desc: "inscrivez-vous ou entrer correctement vos coordonné !",
          btnCancelOnPress: () {
            ref.invalidate(authStateProvider);
          },
          btnOkOnPress: () {
            ref.invalidate(authStateProvider);
          },
        ).show();
      } finally {
        setState(() {
          ischarge = false; // Masque le loader après l'envoi
        });
      }
    } else {
      error = true;
    }
  }

  bool isLoginView = true; // Contrôle la vue active, Login ou Inscription

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
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, 'Home');
              });
            }
            return Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/back.png'),
                ),
              ),
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% de la largeur
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:
                          isLoginView ? screenHeight / 6 : screenHeight / 3.2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        error == true
                            ? SizedBox()
                            : SlideTransition(
                                position: _slideAnimation,
                                child: Text(
                                  'Bienvenue',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'serif',
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: isLoginView ? 18 : 7,
                        ),
                        SlideTransition(
                          position: _slideAnimation,
                          child: Text(
                            isLoginView
                                ? "Connectez-vous pour recevoir les messages exclusifs du Général Makosso en personne."
                                : "Inscrivez-vous pour recevoir les messages exclusifs du Général Makosso en personne.",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'serif',
                              color: Color.fromARGB(255, 110, 110, 110),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: isLoginView ? 30 : 9,
                    ),
                    if (!isLoginView)
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.012, // 1.5% de la hauteur
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 12),
                              labelText: 'Nom et Prénoms',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            validator: (valeur) {
                              if (valeur == null ||
                                  valeur.trim().isEmpty ||
                                  valeur.length >= 50) {
                                return 'Vérifiez le champ nom et prénom';
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
                      ),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: screenHeight * 0.012, // 1.5% de la hauteur
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 12),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          validator: (valeur) {
                            if (valeur == null ||
                                valeur.trim().isEmpty ||
                                valeur.length >= 50) {
                              return 'Votre email est incorrect !';
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
                    ),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: screenHeight * 0.012, // 1.5% de la hauteur
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 12),
                            labelText: 'Mot de passe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
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
                    ),
                    if (!isLoginView)
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.012, // 1.5% de la hauteur
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 12),
                              labelText: 'Pays',
                              labelStyle: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(
                                    255, 41, 102, 33), // Vert spécifique
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 41, 102,
                                      33), // Vert spécifique pour bordure sélectionnée
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 10,
                              ), // Réduit les marges du champ
                            ),
                            value: selectedCountry,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Color.fromARGB(
                                  255, 41, 102, 33), // Vert pour la flèche
                            ),
                            isDense:
                                true, // Rend le champ plus compact verticalement
                            items: countries
                                .map((country) => DropdownMenuItem<String>(
                                      value: country,
                                      child: Text(
                                        country,
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 41, 102,
                                              33), // Vert pour le texte des éléments
                                        ),
                                      ),
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
                      ),
                    if (!isLoginView)
                      SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.012, // 1.5% de la hauteur
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 12),
                              labelText: 'Numéro de téléphone',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            validator: (valeur) {
                              if (valeur == null || valeur.trim().isEmpty) {
                                return 'Veuillez entrer un numéro de téléphone.';
                              }
                              if (valeur.length < 8 || valeur.length > 15) {
                                return 'Le numéro doit comporter entre 8 et 15 chiffres.';
                              }
                              if (!RegExp(r'^\d+$').hasMatch(valeur)) {
                                return 'Le numéro de téléphone doit contenir uniquement des chiffres.';
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
                      ),
                    SizedBox(
                      height: 18,
                    ),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.2,
                              vertical: screenHeight * 0.02,
                            ),
                            foregroundColor: Colors.green,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 10,
                            shadowColor: Colors.green.withOpacity(0.5),
                            side: BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                          onPressed: submit,
                          child: ischarge
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  isLoginView
                                      ? 'Se connecter'.toUpperCase()
                                      : 'S’inscrire'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'serif',
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: isLoginView ? 10 : 7),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLoginView
                                ? "Vous n'avez pas de compte ?"
                                : 'Déjà un compte ?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 146, 146, 146),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isLoginView = !isLoginView;
                              });
                            },
                            child: Text(
                              isLoginView ? "S'inscrire" : "Se connecter",
                              style: TextStyle(
                                color: Color.fromARGB(255, 42, 110, 44),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 38, 114, 41),
                ),
              )),
          error: (error, stackTrace) {
            return SizedBox(
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
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 50,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Une erreur s'est produite ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      " Veuillez vérifier votre connexion internet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
