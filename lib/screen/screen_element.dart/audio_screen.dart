import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:makosso_app/model/audio_model.dart';
import 'package:makosso_app/provider/audio_provider.dart';
import 'package:makosso_app/widgets/home_chargement/audio_liste_chargement.dart';

class AudioScreen extends ConsumerStatefulWidget {
  const AudioScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioScreenState();
}

class _AudioScreenState extends ConsumerState<AudioScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  int _currentIndex = -1;
  Duration _currentPosition = Duration.zero;
  final Map<int, Duration> _audioDurations = {}; // Stocke les durées

  final CacheManager _cacheManager = DefaultCacheManager();
  Duration _audioDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Écoute des changements de position pour mettre à jour _currentPosition
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Gestion de l'état du lecteur pour réinitialiser lorsqu'un audio est terminé
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onAudioComplete();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Gestion de la fin de lecture d'un audio
  void _onAudioComplete() {
    setState(() {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      _currentIndex = -1; // Réinitialisation de l'index
    });
    _audioPlayer.stop(); // Arrêt propre pour éviter les erreurs
  }

  /// Lecture d'un fichier audio
  Future<void> _playAudio(String url, int index) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_currentIndex == index && !_isPlaying) {
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
        await _audioPlayer.play();
        return;
      }
      // Si l'audio actuel est déjà en lecture, arrêtez-le
      if (_currentIndex == index && _isPlaying) {
        setState(() {
          _isPlaying = false;
        });
        await _audioPlayer.pause();
        return;
      }

      // Arrête le lecteur si un autre fichier est en cours
      if (_isPlaying || _currentIndex != index) {
        setState(() {
          _currentPosition = Duration.zero;
          _audioDuration = Duration.zero;
        });
        await _audioPlayer.stop();
      }

      // Vérification si l'audio est déjà en cache
      var cachedFile = await _cacheManager.getSingleFile(url);
      await _audioPlayer.setFilePath(cachedFile.path);

      // Charger l'audio pour obtenir sa durée
      final duration = await _audioPlayer.load();
      if (duration == null) {
        throw Exception('Durée inconnue pour ce fichier audio.');
      }

      setState(() {
        _currentIndex = index;
        _audioDuration = duration;
        _isPlaying = true;
        _isLoading = false;
      });

      // Démarrer la lecture
      await _audioPlayer.play();
    } catch (e) {
      print('Erreur de lecture audio : $e');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: "Une erreur est survenu",
        desc: "Verifier votre connexion internet !",
        btnCancelOnPress: () {
          Navigator.of(context).pop();
        },
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      ).show();
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final asyncAudio = ref.watch(audioProviderList);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.015,
                ),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Image.asset(
                  'assets/images/audio.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                  height: screenHeight * 0.6466,
                  child: asyncAudio.when(
                    data: (audoData) => ListView.builder(
                        itemCount: audoData.length,
                        itemBuilder: (ctx, index) {
                          final AudioModel audio = audoData[index];
                          String? formatDate(DateTime? dateTime) {
                            if (dateTime == null) {
                              return null;
                            }
                            return DateFormat('dd MMM yyyy').format(dateTime);
                          }

                          String? formatHeure(DateTime? dateTime) {
                            if (dateTime == null) {
                              return null;
                            }
                            return DateFormat('hh:mm').format(dateTime);
                          }

                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.015,
                            ),
                            width: screenWidth *
                                0.77, // Largeur de chaque carte audio
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 105, 105, 105)
                                          .withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Bouton de lecture circulaire
                                  CircleAvatar(
                                    radius: screenWidth * 0.07,
                                    backgroundColor:
                                        const Color.fromARGB(255, 46, 100, 48),
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: (_isPlaying &&
                                              _currentIndex == index)
                                          ? IconButton(
                                              key: const ValueKey("pause"),
                                              icon: const Icon(Icons.pause,
                                                  color: Colors.white),
                                              onPressed: () async {
                                                await _audioPlayer.pause();
                                                setState(() {
                                                  _isPlaying = false;
                                                });
                                              },
                                            )
                                          : IconButton(
                                              key: const ValueKey("play"),
                                              icon: const Icon(Icons.play_arrow,
                                                  color: Colors.white),
                                              onPressed: () async {
                                                await _playAudio(
                                                    'https://adminmakossoapp.com/${audio.url}',
                                                    index);
                                              },
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  // Texte (Titre et barre de progression)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          audio.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: screenHeight * 0.005),
                                        LinearProgressIndicator(
                                          backgroundColor: Colors.grey[300],
                                          color: const Color.fromARGB(
                                              255, 36, 95, 38),
                                          value: (_audioDuration.inSeconds > 0)
                                              ? _currentPosition.inSeconds /
                                                  _audioDuration.inSeconds
                                              : 0.0,
                                        ),
                                        SizedBox(height: screenHeight * 0.005),
                                        Row(
                                          children: [
                                            Text(
                                              formatDate(audio.created_at) ??
                                                  'Date inconnue',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.035,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(" / heure "),
                                            Text(
                                              formatHeure(audio.created_at) ??
                                                  'Date inconnue',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.035,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  // Bouton d'action supplémentaire
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: screenWidth * 0.04,
                                    ),
                                    onPressed: () {
                                      print('object');
                                      // Action supplémentaire
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    error: (error, stackTrace) => Text(''),
                    loading: () => AudioListeChargement(),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
