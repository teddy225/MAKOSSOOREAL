import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListeVideoChargement extends StatelessWidget {
  const ListeVideoChargement({super.key});

  @override
  Widget build(BuildContext context) {
    // Dimensions de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02, // Marge verticale dynamique
        horizontal: screenWidth * 0.04, // Marge horizontale dynamique
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: screenHeight * 0.2, // Hauteur adaptative au type d'écran
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(
                      screenWidth * 0.03), // Espacement dynamique
                  child: Container(
                    height: screenHeight * 0.1, // Simule la hauteur du texte
                    width: double.infinity, // Largeur pleine pour le shimmer
                    color: Colors.white, // Couleur du shimmer
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Container(
                  width: screenWidth * 0.25, // Largeur relative pour l'image
                  height: double.infinity, // Hauteur pleine
                  color: Colors.white, // Couleur du shimmer
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
