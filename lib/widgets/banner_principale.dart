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
  final int _totalPages = 10; // Nombre total de bannières

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < _totalPages - 1) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 150, // Hauteur de la bannière
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.textpublication.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        widget.textpublication[index].description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
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
                      width: 100,
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
