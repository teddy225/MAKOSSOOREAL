import 'package:flutter/material.dart';
import 'package:makosso_app/screen/fil_actualite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/auth_provider.dart';
import '../home_screen.dart';

class Tabbarscreen extends ConsumerWidget {
  // Change to ConsumerWidget to use Riverpod context
  const Tabbarscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userProfileProvider);

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
                Expanded(
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
                          SizedBox(width: 4),
                          authState.when(
                            data: (user) {
                              return Text(
                                user.username,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 223, 223, 223),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              return Text("error");
                            },
                            loading: () {
                              return Text("...");
                            },
                          )
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
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                // Déconnexion
                await ref.read(authStateProvider.notifier).logout();
                // Rediriger vers la page de login
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: <Widget>[HomeScreen(), FilActualiteScreen()],
        ),
      ),
    );
  }
}
