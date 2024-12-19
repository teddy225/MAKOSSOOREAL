import 'dart:async';
import 'package:flutter/material.dart';
import 'package:makosso_app/model/text_publication.dart';

class BannerPrincipale extends StatefulWidget {
  const BannerPrincipale({required this.textpublication, super.key});
  final List<TextPublication> textpublication;

  @override
  BannerPrincipaleState createState() => BannerPrincipaleState();
}

class BannerPrincipaleState extends State<BannerPrincipale> {
  final PageController _pageController = PageController();
  late Timer _autoScrollTimer;
  int _currentPage = 0;
  double _scale = 1.0; // Valeur de l'échelle pour l'animation
  bool _isExpanded = false; // Détecter si le container est agrandi ou non

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < widget.textpublication.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Revenir à la première page si la fin est atteinte
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel(); // Arrêter le timer quand le widget est détruit
    _pageController.dispose();
    super.dispose();
  }

  void _onContainerClick(int index) {
    setState(() {
      // Agrandir l'élément au clic
      _isExpanded = !_isExpanded;
      _scale = _isExpanded ? 1.5 : 1.0;
    });

    if (_isExpanded) {
      // Afficher un pop-up avec le texte complet lorsque le container est agrandi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 46, 100, 48),
            content: SingleChildScrollView(
              child: Text(
                widget.textpublication[index].description, // Texte complet
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Fermer', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  setState(() {
                    _isExpanded = false;
                    _scale = 1.0;
                    Navigator.of(context).pop(); // Fermer le pop-up
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: screenHeight * 0.02), // 2% de hauteur
      child: SizedBox(
        height: screenHeight * 0.2, // 20% de hauteur
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.textpublication.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () =>
                  _onContainerClick(index), // Appeler la méthode lors du clic
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03), // 3% de largeur
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(46, 100, 48, 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(
                              screenWidth * 0.03), // 3% de largeur
                          child: Text(
                            widget.textpublication[index].description,
                            maxLines: _isExpanded
                                ? 4
                                : 9, // Afficher tout le texte si agrandi
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenWidth *
                                  0.036, // Taille de police relative
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/p4.png',
                          width: screenWidth * 0.25, // 25% de largeur
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
