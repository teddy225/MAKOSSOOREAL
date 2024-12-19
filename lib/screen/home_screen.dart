import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makosso_app/provider/publication_text.dart';
import 'package:makosso_app/provider/video_provider.dart';
import 'package:makosso_app/widgets/audioliste.dart';
import 'package:makosso_app/widgets/home_chargement/audio_liste_chargement.dart';
import 'package:makosso_app/widgets/home_chargement/banner_principale_chargement.dart';
import 'package:makosso_app/widgets/row_home.dart';
import '../provider/audio_provider.dart';
import '../widgets/banner_principale.dart';
import '../widgets/evenement_liste.dart';
import '../widgets/home_chargement/liste_video_chargement.dart';
import '../widgets/video_liste.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller pour gérer la durée de l'animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Durée de l'animation
    );

    // Animation de défilement vertical (effet de montée)
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Départ depuis le bas
      end: Offset(0, 0), // Arrivée à la position d'origine
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut, // Courbe douce pour un effet naturel
      ),
    );

    // Animation de zoom (scaling) simultanée
    _scaleAnimation = Tween<double>(
      begin: 0.8, // Début de l'échelle (plus petit)
      end: 1.0, // Fin de l'échelle (taille originale)
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Animation de fondu
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Démarrer l'animation dès que l'écran est affiché
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncBannerTexte = ref.watch(textPublicationProvider(0));
    final asyncVideo = ref.watch(videoProviderList);
    final asyncAudio = ref.watch(audioProviderList);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Bannière principale
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation, // Ajout d'un effet de fondu
              child: SlideTransition(
                position: _slideAnimation, // Effet de montée
                child: ScaleTransition(
                  scale: _scaleAnimation, // Effet de zoom
                  child: asyncBannerTexte.when(
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
              ),
            ),
          ),
          // Section audios récents
          const SliverToBoxAdapter(
            child: RowHome(
              titreRecent: 'Audios récents',
              routeName: 'audioScreen',
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: asyncAudio.when(
                      data: (audioData) => Audioliste(audioData: audioData),
                      error: (error, stackTrace) => Text(''),
                      loading: () => AudioListeChargement(),
                    )
                    // Changer pour l'élément réel après chargement
                    ),
              ),
            ),
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: asyncVideo.when(
                    data: (videoData) => VideoListe(
                      videoData: videoData,
                    ),
                    loading: () => ListeVideoChargement(),
                    error: (error, stackTrace) => Text('$error'),
                  ),
                ),
              ),
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
              (context, index) => FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: EvenementListe(), // Liste d'événements
                    ),
                  ),
                ),
              ),
              childCount: 2, // Unique section pour les événements
            ),
          ),
        ],
      ),
    );
  }
}
