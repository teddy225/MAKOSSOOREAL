import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:makosso_app/api/fil_actualite/audio_service.dart';
import 'package:makosso_app/model/audio_model.dart';

// Instance du service pour récupérer les données
final audioProviderService = Provider((ref) => AudioService());

final audioProviderList = FutureProvider<List<AudioModel>>((ref) async {
  final service = ref.watch(audioProviderService);
  return await service.recupererAudio(isFeeded: 0);
});

final selectedAudioProvider = StateProvider<AudioModel?>((ref) => null);

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return player;
});

Future<void> playAudio(WidgetRef ref, AudioModel audio) async {
  final player = ref.read(audioPlayerProvider);
  try {
    if (!audio.url.startsWith('http')) {
      throw Exception('URL invalide : ${audio.url}');
    }
    await player.setUrl(audio.url);
    player.play();
  } catch (e) {
    print('Erreur lors de la lecture : $e');
  }
}

Future<void> togglePlayPause(WidgetRef ref) async {
  final player = ref.read(audioPlayerProvider);
  if (player.processingState == ProcessingState.idle) {
    print("Le lecteur n'a pas d'audio chargé.");
    return;
  }

  if (player.playing) {
    player.pause();
  } else {
    player.play();
  }
}

final audioPlayerStreamProvider = StreamProvider<PlayerState>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.playerStateStream;
});

final audioProgressProvider = StreamProvider<Duration>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.positionStream;
});
