import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/fil_actualite/internet_service.dart';

final internetServiceProvider = Provider<InternetService>(
  (ref) {
    return InternetService();
  },
);
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final internetService = InternetService();
  ref.onDispose(() => internetService.dispose());
  return internetService.streamEtatConnexion;
});
