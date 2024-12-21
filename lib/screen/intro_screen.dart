import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  bool _showIntro = true; // Gère l'état d'affichage des textes initiaux

  @override
  void initState() {
    super.initState();

    // Animation d'entrée
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Début à une position plus basse
      end: Offset(0, 0), // Fin à la position normale
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animation d'opacité
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Lancer l'animation initiale
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTransition() {
    setState(() {
      _showIntro = false;
    });

    // Lancer l'animation pour l'autre contenu après la transition
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacementNamed('authScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(197, 82, 184, 85),
              image: DecorationImage(
                image: AssetImage('assets/images/intro.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (_showIntro)
            // Texte d'introduction avec animation
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: [
                      Text(
                        "Bienvenue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'dans votre application',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Texte secondaire + bouton
          if (_showIntro)
            Positioned(
              bottom: screenHeight * 0.15,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Text(
                          "Avec l'application Makosso, suivez les actualités, prières audio et bien plus.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
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
                        ),
                        onPressed: _startTransition,
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

          // Contenu après la transition
          if (!_showIntro)
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Text(
                  "Chargement...",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
