import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AudioListeChargement extends StatelessWidget {
  const AudioListeChargement({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 90,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          width: 300, // Largeur de chaque carte audio
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Simule le bouton de lecture circulaire
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 5),
                // Simule le texte (Titre et barre de progression)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 14,
                        width: 100,
                        color: Colors.white, // Simule le titre
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 8,
                        width: double.infinity,
                        color: Colors.white, // Simule la barre de progression
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 10,
                        width: 50,
                        color: Colors.white, // Simule la durée
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                // Simule le bouton d'action supplémentaire
                Container(
                  height: 20,
                  width: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
