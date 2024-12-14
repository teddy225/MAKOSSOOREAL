import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:makosso_app/model/video_model.dart';
import 'package:makosso_app/provider/video_provider.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoList = ref.read(videoProviderList).value;
    if (videoList == null || _currentIndex >= videoList.length) return;

    final selectedVideo = videoList[_currentIndex]; // Vidéo actuelle
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://adminmakossoapp.com/${selectedVideo.url}'),
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
        _preloadNextVideo(); // Précharge la vidéo suivante
      }).catchError((error) {
        _showError("Impossible de lire la vidéo : $error");
      });
  }

  void _preloadNextVideo() {
    final videoList = ref.read(videoProviderList).value;
    if (videoList == null || _currentIndex + 1 >= videoList.length) return;

    final nextVideo = videoList[_currentIndex + 1];
    final nextController = VideoPlayerController.networkUrl(
      Uri.parse('https://adminmakossoapp.com/${nextVideo.url}'),
    );
    nextController.initialize().catchError((_) {
      // Erreur silencieuse si le préchargement échoue
    });
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
        title: const Text("Lecture de vidéos"),
      ),
      body: Column(
        children: [
          // Section vidéo principale
          videoList == null || !_controller.value.isInitialized
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 200,
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
          Expanded(
            child: videoList == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: videoList.length,
                    itemBuilder: (context, index) {
                      final video = videoList[index];
                      return ListTile(
                        title: Text(video.title ?? "Vidéo sans titre"),
                        subtitle: Text(video.description ?? ""),
                        selected: index == _currentIndex,
                        selectedTileColor: Colors.grey[200],
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                          });
                          _controller.dispose();
                          _initializePlayer();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
