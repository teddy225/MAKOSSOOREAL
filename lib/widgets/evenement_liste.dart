import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:makosso_app/model/event.dart';

class EvenementListe extends StatefulWidget {
  const EvenementListe({super.key, required this.evenementData});
  final List<Event> evenementData;

  @override
  State<EvenementListe> createState() => _EvenementListeState();
}

class _EvenementListeState extends State<EvenementListe> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.evenementData.length,
        itemBuilder: (ctx, index) {
          final event = widget.evenementData[index];
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01,
              horizontal: screenWidth * 0.03,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 2,
                color: const Color.fromARGB(255, 46, 100, 48),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image avec gestion du chargement et des erreurs
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: 'https://adminmakossoapp.com/${event.urlImage}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      height: screenHeight * 0.28,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color.fromARGB(255, 46, 100, 48),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: screenHeight * 0.28,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre de l'événement
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      // Description
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      // Informations sur le lieu et la date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.date_range_outlined,
                                color: const Color.fromARGB(255, 46, 100, 48),
                                size: screenWidth * 0.05,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                "Date: ${event.date}",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: const Color.fromARGB(255, 46, 100, 48),
                                size: screenWidth * 0.05,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                "Lieu: ${event.lieu}",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
