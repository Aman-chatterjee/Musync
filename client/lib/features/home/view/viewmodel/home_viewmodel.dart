import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:musync/core/providers/current_user_notifier.dart';
import 'package:musync/core/utils.dart';
import 'package:musync/features/home/models/music_model.dart';
import 'package:musync/features/home/repositories/home_local_repository.dart';
import 'package:musync/features/home/repositories/home_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<MusicModel>> getAllMusic(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res =
      await ref.watch(homeRemoteRepositoryProvider).getMusic(token: token);

  return switch (res) {
    fpdart.Left(value: final l) => throw l.message,
    fpdart.Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> getFavMusic(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .getFavoriteMusic(token: token);

  return switch (res) {
    fpdart.Left(value: final l) => throw l.message,
    fpdart.Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRemoteRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRemoteRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadMusic(
      {required File selectedAudio,
      required File selectedImage,
      required String musicName,
      required String artistName,
      required Color selectedColor}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadMusic(
        selectedAudio: selectedAudio,
        selectedImage: selectedImage,
        musicName: musicName,
        artistName: artistName,
        hexCode: rgbToHex(selectedColor),
        token: ref.read(currentUserNotifierProvider)!.token);

    final val = switch (res) {
      fpdart.Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
    };

    //debugPrint(val.toString());
  }

  Future<void> favMusic({required String musicId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository
        .favoriteMusic(
            musicId: musicId,
            token: ref.read(currentUserNotifierProvider)!.token)
        .timeout(Duration(seconds: 10));

    final val = switch (res) {
      fpdart.Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  List<MusicModel> getRecentlyPlayedMusic() {
    return _homeLocalRepository.loadMusic();
  }
}
