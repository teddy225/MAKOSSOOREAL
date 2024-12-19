import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:makosso_app/provider/video_provider.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  int _currentIndex = 0;
  String? _thumbnailPath;

  // Liste des vignettes préchargées
  final Map<int, String> _thumbnailsCache = {};

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoList = ref.read(videoProviderList).value;
    if (videoList == null || _currentIndex >= videoList.length) return;

    final selectedVideo = videoList[_currentIndex];

    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://adminmakossoapp.com/${selectedVideo.url}'),
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
        _preloadNextVideo(); // Précharge la vidéo suivante
        _generateThumbnail(selectedVideo.url); // Génère la vignette
      }).catchError((error) {
        _showError("Impossible de lire la vidéo : $error");
      });
  }

  // Méthode pour générer la vignette
  Future<void> _generateThumbnail(String videoUrl) async {
    try {
      final Uri videoUri = Uri.parse('https://adminmakossoapp.com/$videoUrl');
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoUri.toString(),
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200, // Max width of the thumbnail
        quality: 75, // Image quality (0 to 100)
      );

      setState(() {
        // Cache la vignette dans un map pour les autres vidéos
        _thumbnailsCache[_currentIndex] = thumbnail as String;
        print('Vignette générée avec succès: $thumbnail');
      });
    } catch (e) {
      print('Erreur lors de la génération de la vignette: $e');
    }
  }

  void _preloadNextVideo() {
    final videoList = ref.read(videoProviderList).value;
    if (videoList == null || _currentIndex + 1 >= videoList.length) return;

    final nextVideo = videoList[_currentIndex + 1];
    _generateThumbnail(
        nextVideo.url); // Précharge la vignette de la vidéo suivante
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _playNext() {
    final videoList = ref.read(videoProviderList).value;
    if (videoList == null || _currentIndex >= videoList.length - 1) return;

    setState(() {
      _currentIndex++;
    });
    _controller.dispose();
    _initializePlayer();
  }

  void _playPrevious() {
    if (_currentIndex <= 0) return;

    setState(() {
      _currentIndex--;
    });
    _controller.dispose();
    _initializePlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoList = ref.watch(videoProviderList).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lecture vidéo"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section vidéo principale
          videoList == null || !_controller.value.isInitialized
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 240,
                    color: Colors.white,
                  ),
                )
              : AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.fast_rewind,
                    size: 30, color: const Color.fromARGB(255, 37, 110, 40)),
                onPressed: _playPrevious,
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30,
                  color: const Color.fromARGB(255, 37, 110, 40),
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.fast_forward,
                    size: 30, color: const Color.fromARGB(255, 37, 110, 40)),
                onPressed: _playNext,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Section liste des vidéos
          Container(
            padding: const EdgeInsets.only(left: 5, bottom: 5),
            child: ReadMoreText(
              """ Description :  ${videoList![_currentIndex].description}""",
              style: Theme.of(context).textTheme.bodyMedium,
              trimMode: TrimMode.Line,
              trimLines: 3,
              trimCollapsedText: 'Afficher la suite',
              trimExpandedText: ' Afficher moin',
              moreStyle: Theme.of(context).textTheme.bodySmall,
              lessStyle: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: videoList == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: videoList.length,
                    itemBuilder: (context, index) {
                      final video = videoList[index];

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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 202, 202, 202),
                          ),
                        ),
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Afficher la vignette si elle est dans le cache
                            _thumbnailsCache.containsKey(index)
                                ? SizedBox(
                                    width: 150,
                                    height: 122,
                                    child: Image.file(
                                      File(_thumbnailsCache[index]!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SizedBox(
                                    width: 150,
                                    height: 75,
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                  _controller.dispose();
                                  _initializePlayer();
                                },
                                child: Container(
                                  color: index == _currentIndex
                                      ? const Color.fromARGB(111, 15, 50, 11)
                                      : const Color.fromARGB(
                                          255, 255, 255, 255),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 9, left: 9),
                                        child: Text(
                                          video.description,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Publié le ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 88, 88, 88),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5, left: 10),
                                        child: Text(
                                          "${formatDate(video.created_at)}  à ${formatHeure(video.created_at)}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 119, 119, 119),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
