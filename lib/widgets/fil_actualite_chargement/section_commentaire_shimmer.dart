import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionCommentaireShimmer extends StatelessWidget {
  const SectionCommentaireShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 200, 200, 200),
          highlightColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.favorite,
                      size: 24,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("", style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(width: 5),
                    Text(
                      'commentaires',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 10),
                    Text("0", style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(width: 5),
                    Text(
                      'partages',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 22),
                    const SizedBox(width: 4),
                    Text("J'aime",
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.message, size: 22),
                    const SizedBox(width: 4),
                    Text("Commenter",
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.share, size: 22),
                    const SizedBox(width: 4),
                    Text("Partager",
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
