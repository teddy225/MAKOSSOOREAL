import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PosteurShimmer extends StatelessWidget {
  const PosteurShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // CircleAvatar avec shimmer
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 214, 214, 214),
            highlightColor: Colors.white,
            child: const CircleAvatar(
              radius: 25, // Taille ajustée pour l'effet
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texte shimmer pour le nom
                Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 214, 214, 214),
                  highlightColor: Colors.white,
                  child: Container(
                    width: 150,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                ),
                // Texte shimmer pour la durée
                Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 214, 214, 214),
                  highlightColor: Colors.white,
                  child: Container(
                    width: 100,
                    height: 12,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}