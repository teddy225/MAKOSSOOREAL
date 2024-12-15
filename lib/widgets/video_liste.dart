import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makosso_app/model/video_model.dart';
import 'package:makosso_app/provider/video_provider.dart';
import 'package:makosso_app/screen/screen_element.dart/video_player_screen.dart';

class VideoListe extends StatelessWidget {
  const VideoListe({required this.videoData, super.key});
  final List<VideoModel> videoData;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: SizedBox(
        height: screenHeight * 0.24,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: videoData.length,
          itemBuilder: (context, index) {
            final video = videoData[index];
            return Consumer(
              builder: (context, ref, child) {
                return InkWell(
                  onTap: () {
                    ref.read(selectedVideoProvider.notifier).state = video;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoPlayerScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.8,
                    margin:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 2,
                        color: Colors.green,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Vérifier si la miniature est disponible
                          video.thumbnail != null
                              ? Image.memory(
                                  video.thumbnail as Uint8List,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Container(
                                  color: Colors.black12,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 60,
                                    ),
                                  ),
                                ),
                          Positioned(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white.withOpacity(0.8),
                              size: 80,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
