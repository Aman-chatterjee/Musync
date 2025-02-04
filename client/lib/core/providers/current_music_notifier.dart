// ignore_for_file: avoid_public_notifier_properties
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musync/features/home/models/music_model.dart';
import 'package:musync/features/home/repositories/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_music_notifier.g.dart';

@riverpod
class CurrentMusicNotifier extends _$CurrentMusicNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  MusicModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateMusic(MusicModel music) async {
    audioPlayer = audioPlayer ?? AudioPlayer();
    if (isPlaying) audioPlayer!.stop();

    final audioSource = AudioSource.uri(
      Uri.parse(music.music_url),
      tag: MediaItem(
          id: music.id,
          artist: music.artist_name,
          title: music.music_name,
          artUri: Uri.parse(music.thumbnail_url),
          duration: audioPlayer!.duration),
    );
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen((st) {
      if (st.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        state = state?.copyWith(hex_code: state?.hex_code);
      }

      //Monitering play pause state
      isPlaying = audioPlayer!.playing;
      state = state?.copyWith(hex_code: state?.hex_code);
    });

    _homeLocalRepository.uploadLoaclMusic(music);
    audioPlayer!.play();
    isPlaying = !isPlaying;
    state = music;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
  }

  void seek(double val) {
    audioPlayer!.seek(Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt()));
  }
}
