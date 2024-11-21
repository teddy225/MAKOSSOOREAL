import 'package:flutter/material.dart';

class VideoListe extends StatelessWidget {
  const VideoListe({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenez la taille de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical:
            screenHeight * 0.01, // Ajuste la marge verticale dynamiquement
      ),
      child: SizedBox(
        height:
            screenHeight * 0.24, // Hauteur de la bannière relative à l'écran
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              width:
                  screenWidth * 0.8, // Largeur de l'élément relative à l'écran
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025, // Marge horizontale dynamique
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 2,
                  color: Colors.green,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Ombre pour un effet visuel
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.center, // Centre le bouton Play
                  children: [
                    // Image de fond
                    Image.asset(
                      'assets/images/p8.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    // Bouton Play au centre
                    Positioned(
                      left: 120,
                      top: 50,
                      child: IconButton(
                        icon: Icon(
                          Icons.play_circle_fill,
                          color: const Color.fromARGB(185, 255, 255, 255),
                          size: 80, // Taille du bouton
                        ),
                        onPressed: () {
                          // Action à réaliser lors de l'appui sur le bouton play
                          print('Lecture vidéo');
                        },
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
