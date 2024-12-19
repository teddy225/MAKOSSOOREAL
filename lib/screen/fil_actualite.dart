import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/fil_actualite_provider.dart';
import '../provider/commentaire_provider.dart'; // Assurez-vous d'importer le provider des commentaires
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
    final asyncFilActualite = ref.watch(filActualiteStreamProvider);

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
                            offset: const Offset(0, 10), // Décalage de l'ombre
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Posteur(
                              dateposte: filactualite.created_at as DateTime),
                          Description(description: filactualite.description),
                          Poste(imageUrl: filactualite.url),

                          // Afficher le nombre de commentaires
                          SectionCommentaire(
                            nombreCommentaire: 1, // Nombre de commentaires réel
                            nombreLike:
                                0, // Ajustez si nécessaire pour afficher les likes
                            idcommentaire: filactualite.id,
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
      error: (error, stackTrace) => SizedBox(
        height: screenHeight,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.close,
                  size: 40,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Une erreur s'est produite",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              Text(
                "$error",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 10,
                    bottom: 10,
                  ),
                ),
                onPressed: () {
                  ref.invalidate(filActualiteStreamProvider);
                },
                child: Text('Réessayer'),
              )
            ],
          ),
        ),
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
                            offset: const Offset(0, 10), // Décalage de l'ombre
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
      ),
    );
  }
}
