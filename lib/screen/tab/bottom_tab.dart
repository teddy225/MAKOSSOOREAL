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
        return AlertDialog(
          title: Column(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.close,
                  size: 40,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                Text(
                  'Pas de connexion internet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Vérifiez votre connexion internet.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.only(
                        left: 40,
                        right: 40,
                        top: 10,
                        bottom: 10,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Réessayer'),
                )
              ],
            ),
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
    final screenHeight = MediaQuery.of(context).size.height;

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
          return SizedBox(
            height: screenHeight,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      Icons.close,
                      size: 50,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Une erreur s'est  produite ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    " Veillez verifier votre connection internet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.only(
                          left: 40,
                          right: 40,
                          top: 10,
                          bottom: 10,
                        )),
                    onPressed: () {
                      ref.invalidate(connectivityStreamProvider);
                    },
                    child: Text('Réessayer'),
                  )
                ],
              ),
            ),
          );
        },
        loading: () {
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
