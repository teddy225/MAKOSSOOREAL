import 'package:flutter/material.dart';
import 'package:makosso_app/screen/fil_actualite.dart';

import '../home_screen.dart';

class Tabbarscreen extends StatelessWidget {
  const Tabbarscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 175, 255, 161), // Couleur de la bordure
                        width: 3, // Épaisseur de la bordure
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/p2.jpg'),
                      radius: 24, // Taille de l'avatar
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bienvenue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Teddy Ange',
                              style: TextStyle(
                                color: Color.fromARGB(255, 223, 223, 223),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Que cette journée vous soit bénie',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Accueil',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Fil d\'actualité',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[HomeScreen(), FilActualiteScreen()],
          ),
        ));
  }
}
