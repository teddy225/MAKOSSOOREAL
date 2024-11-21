import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/fil_actualite/publication_text.dart';
import '../model/text_publication.dart';

// Instance du service pour récupérer les données
final TextpublicationProvider = Provider((ref) => TextpublicationService());

// FutureProvider pour la récupération des posts
final textPublicationProvider =
    FutureProvider.family<List<TextPublication>, int>((ref, isFeeded) async {
  final service = ref.watch(TextpublicationProvider);
  return await service.recupererPublicationText(isFeeded: isFeeded);
});
