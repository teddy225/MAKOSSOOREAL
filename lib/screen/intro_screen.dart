import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key, required this.basculConnexion});
  final Function() basculConnexion;

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Animation pour le décalage du texte et bouton
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0.2), // Début à une position plus basse
      end: Offset(0, 0), // Fin à la position normale
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animation d'opacité
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Démarre l'animation lors de l'initialisation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Image de fond
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(197, 82, 184, 85),
            image: DecorationImage(
              image:
                  AssetImage('assets/images/intro.jpeg'), // Chemin de l'image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Dégradé en haut de l'image
        Positioned(
            top: 400,
            left: -10,
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bienvenue ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08, // Taille responsive
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        'dans votre',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08, // Taille responsive
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        'application',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08, // Taille responsive
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),

        // Contenu avec animation
        Positioned(
          bottom: 0,
          child: SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Texte principal

                    SizedBox(height: screenHeight * 0.02),
                    // Texte secondaire
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Text(
                        "Avec l'application Makosso, suivez exclusivement les actualités Du Pasteur Générale Camille MAKOSSO: priere audio ,clute en video et bein plus encore",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: const Color.fromARGB(200, 255, 255, 255),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    // Bouton "Démarrer"
                    ElevatedButton(
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
                      onPressed: widget.basculConnexion,
                      child: Text(
                        "Démarrer",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
