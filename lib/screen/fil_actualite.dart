import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/fil_actualite_provider.dart';
import '../widgets/fil_actualite/description.dart';
import '../widgets/fil_actualite/poste.dart';
import '../widgets/fil_actualite/posteur.dart';
import '../widgets/fil_actualite/section_commentaire.dart';
import '../widgets/fil_actualite_chargement/description.dart';
import '../widgets/fil_actualite_chargement/poste_shimmer.dart';
import '../widgets/fil_actualite_chargement/posteur_shimmer.dart';
import '../widgets/fil_actualite_chargement/section_commentaire_shimmer.dart';

class FilActualiteScreen extends ConsumerWidget {
  const FilActualiteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFilActualite = ref.watch(filActualiteProvider(
        1)); // `false` indique qu'on charge les posts non-feedés

    // Récupérer les dimensions de l'écran pour ajuster les marges et les tailles
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return asyncFilActualite.when(
        data: (filactualites) => CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final filactualite = filactualites[index];
                      print(filactualites.length);
                      return Column(
                        children: [
                          SizedBox(
                            height: screenHeight *
                                0.02, // Hauteur adaptative en fonction de l'écran
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 235, 235),
                              borderRadius: BorderRadius.circular(
                                  screenWidth * 0.03), // Rayon adaptatif
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.3), // Couleur de l'ombre
                                  spreadRadius: 10, // Expansion de l'ombre
                                  blurRadius: 10, // Flou de l'ombre
                                  offset: const Offset(
                                      0, 10), // Décalage de l'ombre
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Posteur(
                                  dateposte:
                                      filactualite.created_at as DateTime,
                                ),
                                Description(
                                  description: filactualite.description,
                                ),
                                Poste(
                                  imageUrl: filactualite.url,
                                ),
                                SectionCommentaire(
                                  nombreCommentaire: 0,
                                  nombreLike: 0,
                                ),
                                const SizedBox(
                                  height: 5, // Ajustement de l'espacement
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: filactualites.length,
                  ),
                ),
              ],
            ),
        error: (error, stackTrace) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Une erreur est survenue : ${error.toString()}',
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(filActualiteProvider(1)); // Réessayer
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
        loading: () => CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: screenHeight *
                                0.02, // Hauteur adaptative en fonction de l'écran
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 235, 235),
                              borderRadius: BorderRadius.circular(
                                  screenWidth * 0.03), // Rayon adaptatif
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.3), // Couleur de l'ombre
                                  spreadRadius: 10, // Expansion de l'ombre
                                  blurRadius: 10, // Flou de l'ombre
                                  offset: const Offset(
                                      0, 10), // Décalage de l'ombre
                                ),
                              ],
                            ),
                            child: const Column(
                              children: [
                                PosteurShimmer(),
                                DescriptionShimmer(),
                                PosteShimmer(),
                                SectionCommentaireShimmer(),
                                SizedBox(
                                  height: 5, // Ajustement de l'espacement
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    childCount: 2,
                  ),
                )
              ],
            ));
  }
}
