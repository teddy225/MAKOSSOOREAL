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
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03), // 3% de largeur
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 100, 48),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.all(screenWidth * 0.03), // 3% de largeur
                      child: Text(
                        widget.textpublication[index].description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.045, // Taille de police relative
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
            );
          },
        ),
      ),
    );
  }
}
