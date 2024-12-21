import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makosso_app/api/fil_actualite/evenement_service.dart';
import 'package:makosso_app/model/event.dart';

// Instance du service pour récupérer les données
final evenetServiceProvider = Provider((ref) => EventService());

final evenetLisProvider = FutureProvider<List<Event>>((ref) async {
  final service = ref.watch(evenetServiceProvider);
  return await service.recupererEvenements(isFeeded: 0);
});
