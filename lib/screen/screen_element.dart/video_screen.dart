import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:makosso_app/screen/screen_element.dart/video_player_screen.dart';
import 'package:video_player/video_player.dart';

import '../../provider/video_provider.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  Widget build(BuildContext context) {
    final videoList = ref.watch(videoProviderList).value;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lecture vidéo 1"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              image: const DecorationImage(
                image: AssetImage('assets/images/video.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Section vidéo principale

          const SizedBox(height: 10),
          // Section liste des vidéos

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

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                currentIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
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
                              SizedBox(
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/p8.jpg',
                                    height: 120,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 9, left: 9),
                                        child: Text(
                                          video.description,
                                          maxLines: 3,
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
                            ],
                          ),
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
