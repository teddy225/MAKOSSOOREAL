import 'package:flutter/material.dart';

class SectionCommentaire extends StatelessWidget {
  const SectionCommentaire(
      {super.key, required this.nombreCommentaire, required this.nombreLike});
  final int nombreCommentaire;
  final int nombreLike;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  nombreLike.toString(),
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
                Text(nombreCommentaire.toString(),
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(width: 5),
                Text(
                  'commentaires',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("28", style: Theme.of(context).textTheme.labelLarge),
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
      Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, size: 22),
                const SizedBox(
                  width: 4,
                ),
                Text("J'aime", style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.message, size: 22),
                const SizedBox(
                  width: 4,
                ),
                Text("Commenter",
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.share, size: 22),
                const SizedBox(
                  width: 4,
                ),
                Text("Partager",
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}