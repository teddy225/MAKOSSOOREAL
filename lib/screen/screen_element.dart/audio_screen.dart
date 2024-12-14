import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioScreen extends ConsumerStatefulWidget {
  const AudioScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioScreenState();
}

class _AudioScreenState extends ConsumerState<AudioScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                  'assets/images/p001.png',
                ),
              ),
              SizedBox(
                height: screenHeight * 0.6466,
                child: ListView.builder(itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.015,
                    ),
                    width: screenWidth * 0.77, // Largeur de chaque carte audio
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 105, 105, 105)
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
                                const Color.fromARGB(255, 105, 240, 123),
                            child: IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: screenWidth * 0.07,
                              ),
                              onPressed: () {
                                // Action de lecture
                              },
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          // Texte (Titre et barre de progression)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "message du samedi 24 aout 2024",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                LinearProgressIndicator(
                                  value: 0.5, // Simule la progression
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.green,
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  "04:24",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: screenWidth * 0.03,
                                  ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
