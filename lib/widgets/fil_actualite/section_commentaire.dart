import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/commentaire_provider.dart';

class SectionCommentaire extends StatelessWidget {
  const SectionCommentaire(
      {super.key,
      required this.nombreCommentaire,
      required this.nombreLike,
      required this.idcommentaire});
  final int nombreCommentaire;
  final int nombreLike;
  final int idcommentaire;

  void showCommentsModal({required BuildContext context, required int postId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            final commentsAsyncValue =
                ref.watch(commentaireStreamProvider(postId));

            return commentsAsyncValue.when(
              data: (comments) {
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      title: Text(comment.content),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Erreur: $error')),
            );
          },
        );
      },
    );
  }

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
                InkWell(
                  onTap: () {
                    print(idcommentaire);
                  },
                  child: Text(
                    'commentaires',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
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
