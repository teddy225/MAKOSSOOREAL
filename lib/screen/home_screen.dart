import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makosso_app/provider/publication_text.dart';
import 'package:makosso_app/provider/video_provider.dart';
import 'package:makosso_app/widgets/home_chargement/audio_liste_chargement.dart';
import 'package:makosso_app/widgets/home_chargement/banner_principale_chargement.dart';
import 'package:makosso_app/widgets/row_home.dart';
import '../widgets/banner_principale.dart';
import '../widgets/evenement_liste.dart';
import '../widgets/home_chargement/liste_video_chargement.dart';
import '../widgets/video_liste.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBannerTexte = ref.watch(textPublicationProvider(0));
    final asyncVideo = ref.watch(videoProviderList);
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
                return BannerPrincipaleChargement();
              },
              loading: () {
                return BannerPrincipaleChargement();
              },
            ),
          ),
          // Section audios récentsk
          const SliverToBoxAdapter(
            child: RowHome(
              titreRecent: 'Audios récents',
              routeName: 'audioScreen',
            ),
          ),
          SliverToBoxAdapter(
              child: AudioListeChargement() //AudioListeChargement(),
              //     asyncAudio.when(
              //   data: (audioData) {
              //     return Audioliste(
              //       audioData: audioData,
              //     );
              //   },
              //   loading: () {
              //     return AudioListeChargement();
              //   },
              //   error: (error, stackTrace) {
              //     return Text('$error');
              //   },
              // ),
              ),
          // Section vidéos récentes
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: RowHome(
                titreRecent: 'Videos récentes',
                routeName: 'videoScreen',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: // ListeVideoChargement(),
                asyncVideo.when(
              data: (videoData) => VideoListe(
                videoData: videoData,
              ),
              loading: () => ListeVideoChargement(),
              error: (error, stackTrace) => Text('$error'),
            ),
          ),
          // Section événements
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: RowHome(
                titreRecent: 'Événements',
                routeName: '',
              ),
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
  }
}
