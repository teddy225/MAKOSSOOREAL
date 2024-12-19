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
          backgroundColor: const Color.fromARGB(255, 46, 100, 48),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Row(
              children: [
                Container(),
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
                                user.username.toUpperCase(),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 223, 223, 223),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              return Text("error $error");
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
                          fontSize: 15,
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
                    fontSize: 18,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Fil d\'actualité',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () async {
                await ref.read(authStateProvider.notifier).logout();
                // Rediriger vers la page de login
                Navigator.pushReplacementNamed(context, 'authScreen');
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ),
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
