import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _etatConnectionController =
      StreamController<bool>.broadcast();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  InternetService() {
    // Écoute les changements de connectivité
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (connectivityResults) {
        try {
          // Parcourir la liste des résultats de connectivité
          bool estConnecte = _isAnyConnected(connectivityResults);
          _etatConnectionController.add(estConnecte);
        } catch (error) {
          _etatConnectionController.addError(
              "Erreur lors de la vérification de la connexion: $error");
        }
      },
    );
  }

  Stream<bool> get streamEtatConnexion => _etatConnectionController.stream;

  // Méthode pour vérifier la connexion Internet manuellement
  Future<bool> checkLaConnexionInternet() async {
    try {
      List<ConnectivityResult> resultatsConnexion =
          await _connectivity.checkConnectivity();
      return _isAnyConnected(resultatsConnexion);
    } catch (error) {
      print("Erreur lors de la vérification de la connexion: $error");
      return false;
    }
  }

  // Vérifie si au moins une interface est connectée dans la liste
  bool _isAnyConnected(List<ConnectivityResult> results) {
    for (var result in results) {
      if (_isConnected(result)) {
        return true;
      }
    }
    return false;
  }

  // Vérifie si un seul ConnectivityResult est connecté (mobile, wifi ou ethernet)
  bool _isConnected(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.none:
      default:
        return false;
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }

  // Libère les ressources
  void dispose() {
    _etatConnectionController.close();
    _connectivitySubscription.cancel();
  }
}
