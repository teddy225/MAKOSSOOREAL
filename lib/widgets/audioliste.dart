import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:makosso_app/model/audio_model.dart';

class Audioliste extends StatefulWidget {
  const Audioliste({required this.audioData, super.key});
  final List<AudioModel> audioData;

  @override
  State<Audioliste> createState() => _AudiolisteState();
}

class _AudiolisteState extends State<Audioliste> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  int _currentIndex = -1;
  final Map<int, Duration> _currentPositions = {}; // Positions individuelles
  final CacheManager _cacheManager = DefaultCacheManager();
  Duration _audioDuration = Duration.zero;
  final Map<int, Duration> _audioDurations = {}; // Stocke les durées

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _preloadAudioDurations();

    // Écoute les changements de position pour mettre à jour la position actuelle uniquement pour l'index courant
    _audioPlayer.positionStream.listen((position) {
      if (_currentIndex != -1) {
        setState(() {
          _currentPositions[_currentIndex] = position;
        });
      }
    });

    // Gestion de la fin de lecture d'un fichier audio
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onAudioComplete();
      }
    });
  }

  Future<void> _preloadAudioDurations() async {
    for (int index = 0; index < widget.audioData.length; index++) {
      final audio = widget.audioData[index];
      final url = 'https://adminmakossoapp.com/${audio.url}';

      try {
        // Vérifiez si l'audio est déjà en cache
        final cachedFile = await _cacheManager.getSingleFile(url);
        // Utilisation du chemin du fichier caché pour obtenir la durée
        final audioPlayer = AudioPlayer();
        await audioPlayer.setFilePath(cachedFile.path);
        final duration = await audioPlayer.load();
        setState(() {
          _audioDurations[index] = duration ?? Duration.zero;
        });
      } catch (e) {
        print('Erreur lors du préchargement de la durée : $e');
        setState(() {
          _audioDurations[index] = Duration.zero;
        });
      }
    }
  }

  /// Gestion de la fin de lecture d'un audio
  void _onAudioComplete() {
    setState(() {
      _isPlaying = false;
      _currentIndex = -1; // Réinitialisation de l'index
    });
    _audioPlayer.stop(); // Arrêt propre pour éviter les erreurs
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Lecture ou reprise d'un fichier audio
  Future<void> _playAudio(String url, int index) async {
    try {
      if (_currentIndex == index) {
        if (_isPlaying) {
          // Pause si l'audio est en cours de lecture

          setState(() {
            _isPlaying = false;
          });
          await _audioPlayer.pause();
        } else {
          // Reprendre la lecture depuis la position actuelle

          setState(() {
            _isPlaying = true;
          });
          await _audioPlayer.play();
        }
        return;
      }

      // Si un autre fichier est en cours de lecture, arrêtez-le
      if (_currentIndex != -1 && _currentIndex != index) {
        setState(() {
          _currentPositions[_currentIndex] = Duration.zero;
        });
        await _audioPlayer.stop();
      }

      // Préparez le fichier audio
      var cachedFile = await _cacheManager.getSingleFile(url);
      await _audioPlayer.setFilePath(cachedFile.path);

      // Si une position existante est sauvegardée, reprenez à cette position
      if (_currentPositions.containsKey(index)) {
        await _audioPlayer.seek(_currentPositions[index]!);
      }

      // Démarrer la lecture
      setState(() {
        _currentIndex = index;
        _isPlaying = true;
      });
      await _audioPlayer.play();
    } catch (e) {
      print('Erreur de lecture audio : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.10,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        itemCount: widget.audioData.length,
        itemBuilder: (context, index) {
          final audio = widget.audioData[index];
          final duration = _audioDurations[index] ?? Duration.zero;
          final position = _currentPositions[index] ?? Duration.zero;

          return Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01,
              horizontal: screenWidth * 0.015,
            ),
            width: screenWidth * 0.77,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
                  CircleAvatar(
                    radius: screenWidth * 0.07,
                    backgroundColor: const Color.fromARGB(255, 46, 100, 48),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: (_isPlaying && _currentIndex == index)
                          ? IconButton(
                              key: const ValueKey("pause"),
                              icon:
                                  const Icon(Icons.pause, color: Colors.white),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          audio.description,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        LinearProgressIndicator(
                          backgroundColor: Colors.grey[300],
                          color: const Color.fromARGB(255, 46, 100, 48),
                          value: (duration.inSeconds > 0)
                              ? position.inSeconds / duration.inSeconds
                              : 0.0,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Row(
                          children: [
                            Text(
                              _formatDuration(duration),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _formatDuration(position),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: screenWidth * 0.04,
                    ),
                    onPressed: () {
                      print('Favori ajouté pour ${audio.title}');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
