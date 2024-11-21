import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makosso_app/provider/publication_text.dart';

import 'package:makosso_app/widgets/home_chargement/banner_principale_chargement.dart';
import 'package:makosso_app/widgets/home_chargement/liste_video_chargement.dart';
import 'package:makosso_app/widgets/row_home.dart';

import '../provider/fil_actualite_provider.dart';
import '../widgets/audioliste.dart';
import '../widgets/banner_principale.dart';
import '../widgets/evenement_liste.dart';
import '../widgets/video_liste.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBannerTexte = ref.watch(textPublicationProvider(0));
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Bannière principale
          SliverToBoxAdapter(
            child: //
                asyncBannerTexte.when(
              data: (textpublication) {
                return BannerPrincipale(textpublication: textpublication);
              },
              error: (error, stackTrace) {
                return Text("Une erreur c'est produit");
              },
              loading: () {
                return BannerPrincipaleChargement();
              },
            ),
          ),
          // Section audios récents
          const SliverToBoxAdapter(
            child: RowHome(titreRecent: 'Audios récents'),
          ),
          const SliverToBoxAdapter(
            child: //AudioListeChargement(),
                Audioliste(),
          ),
          // Section vidéos récentes
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: RowHome(titreRecent: 'Videos récentes'),
            ),
          ),
          const SliverToBoxAdapter(
            child: // ListeVideoChargement(),
                VideoListe(),
          ),
          // Section événements
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: RowHome(titreRecent: 'Événements'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: EvenementListe(), // Liste d'événements
              ),
              childCount: 2, // Unique section pour les événements
            ),
          ),
        ],
      ),
    );
    ;
  }
}
