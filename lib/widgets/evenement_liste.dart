import 'package:flutter/material.dart';

class EvenementListe extends StatelessWidget {
  const EvenementListe({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenez la taille de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.45, // Hauteur totale pour l'événement
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01, // Marge verticale
          horizontal: screenWidth * 0.05, // Marge horizontale
        ),
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
              offset: const Offset(0, 3), // Ombre pour un effet visuel
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image en haut
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                'assets/images/p7.jpg',
                height: screenHeight * 0.279,
                width: double.infinity,
                fit: BoxFit.cover, // Adapter l'image
              ),
            ),
            // Espace pour les détails
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
                    "Titre de l'événement",
                    style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.005), // Espacement
                  // Description
                  Text(
                    "Description courte de l'événement ici. Cet événement est très intéressant et unique. je suis le developpeur de la nation dsdsdsdsd",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.black54,
                    ),
                    maxLines: 2, // Limiter la description
                    overflow: TextOverflow.ellipsis, // Ellipsis si trop long
                  ),
                  SizedBox(height: screenHeight * 0.005), // Espacement
                  // Lieu de l'événement
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.011,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              color: Colors.green,
                              size: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              "Date : 24 juin 2025",
                              style: TextStyle(
                                fontSize: screenWidth * 0.033,
                                color: const Color.fromARGB(221, 34, 34, 34),
                              ),
                            ),
                          ],
                        ),

                        // Icône "like"
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: screenWidth * 0.05,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              "Lieu : yopougon Siporex",
                              style: TextStyle(
                                fontSize: screenWidth * 0.033,
                                color: const Color.fromARGB(221, 34, 34, 34),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.favorite_border,
                          size: screenWidth * 0.05,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
