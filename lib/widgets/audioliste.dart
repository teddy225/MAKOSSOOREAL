import 'package:flutter/material.dart';

class Audioliste extends StatelessWidget {
  const Audioliste({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenez la taille de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Exemple de données
    final audioData = [
      {"title": "Note vocale 1", "duration": "2:15"},
      {"title": "Note vocale 2", "duration": "1:45"},
      {"title": "Note vocale 3", "duration": "3:30"},
      {"title": "Note vocale 4", "duration": "4:05"},
    ];

    return SizedBox(
      height: screenHeight * 0.10, // Hauteur totale de la liste horizontale
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        itemCount: audioData.length,
        itemBuilder: (context, index) {
          final audio = audioData[index];
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01,
              horizontal: screenWidth * 0.015,
            ),
            width: screenWidth * 0.77, // Largeur de chaque carte audio
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 105, 105, 105).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bouton de lecture circulaire
                  CircleAvatar(
                    radius: screenWidth * 0.07,
                    backgroundColor: const Color.fromARGB(255, 105, 240, 123),
                    child: IconButton(
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: screenWidth * 0.05,
                      ),
                      onPressed: () {
                        // Action de lecture
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  // Texte (Titre et barre de progression)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          audio["title"]!,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        LinearProgressIndicator(
                          value: 0.5, // Simule la progression
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          audio["duration"]!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  // Bouton d'action supplémentaire
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: screenWidth * 0.04,
                    ),
                    onPressed: () {
                      print('object');
                      // Action supplémentaire
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
