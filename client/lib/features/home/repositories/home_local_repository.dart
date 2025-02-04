import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musync/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box('musync');

  void uploadLoaclMusic(MusicModel music) {
    var temp = music.copyWith(
      created_at: DateTime.now(),
    );
    box.put(music.id, temp.toJson());
  }

  List<MusicModel> loadMusic() {
    List<MusicModel> musicList = [];
    for (final key in box.keys) {
      musicList.add(MusicModel.fromJson(box.get(key)));
    }

    if (musicList.isNotEmpty) {
      musicList.sort((a, b) => b.created_at.compareTo(a.created_at));
    }
    return musicList;
  }
}
