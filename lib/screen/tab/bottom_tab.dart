import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makosso_app/provider/internet_service_provider.dart';
import 'package:makosso_app/screen/tab/tabbar.dart';

class BottomNavbar extends ConsumerStatefulWidget {
  const BottomNavbar({super.key});

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends ConsumerState<BottomNavbar> {
  // L'index est maintenant géré via Riverpod
  // Exemple d'un provider pour l'index de la navigation
  final _indexProvider = StateProvider<int>((ref) => 0);

  void showConnectionErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return const AlertDialog(
          title: Text(
            'Pas de connexion internet',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          content: Text(
            'Vérifiez votre connexion internet.',
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  List<Widget> list = [
    const Tabbarscreen(),
    Container(color: Colors.white),
    Container(color: Colors.white),
    Container(color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final index = ref.watch(
        _indexProvider); // Utilisation de `watch` pour écouter l'état du provider
    final etatConnexion = ref.watch(connectivityStreamProvider);
    ref.listen(connectivityStreamProvider, (prevu, next) {
      if (next.value == false) {
        showConnectionErrorDialog(context);
      }
    });
    return Scaffold(
      body: etatConnexion.when(
        data: (isconnected) {
          return isconnected
              ? list[index]
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
        error: (error, stackTrace) {
          return Text('Erreur est survenue');
        },
        loading: () {
          print('lol');
          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.035,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.03,
            ),
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey[400],
            currentIndex: index,
            onTap: (value) {
              // Mise à jour de l'état via le provider
              ref.read(_indexProvider.notifier).state = value;
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 24),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 24),
                label: 'Produits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message, size: 24),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.live_tv_sharp, size: 24),
                label: 'Live',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
