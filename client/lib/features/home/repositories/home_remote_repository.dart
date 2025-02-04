import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:musync/core/constants/server_constants.dart';
import 'package:musync/core/faliure/failure.dart';
import 'package:musync/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_remote_repository.g.dart';

@riverpod
HomeRemoteRepository homeRemoteRepository(Ref ref) {
  return HomeRemoteRepository();
}

class HomeRemoteRepository {
  Future<Either<AppFailure, String>> uploadMusic({
    required File selectedAudio,
    required File selectedImage,
    required String musicName,
    required String artistName,
    required String hexCode,
    required String token,
  }) async {
    try {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstans.serverURL}/music/upload'),
      );

      req
        ..files.addAll([
          await http.MultipartFile.fromPath('music', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll({
          'artist_name': artistName,
          'music_name': musicName,
          'hex_code': hexCode,
        })
        ..headers.addAll({
          'x-auth-token': token,
        });

      final res = await req.send().timeout(Duration(seconds: 10));

      if (res.statusCode != 201) {
        return Left(AppFailure(message: await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getMusic(
      {required String token}) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstans.serverURL}/music/list'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      }).timeout(Duration(seconds: 10));

      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(message: resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as List;
      List<MusicModel> music = [];
      for (final map in resBodyMap) {
        music.add(MusicModel.fromMap(map));
      }
      return Right(music);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
