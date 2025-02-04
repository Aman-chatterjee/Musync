// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class MusicModel {
  final String id;
  final String music_name;
  final String artist_name;
  final String music_url;
  final String thumbnail_url;
  final String hex_code;
  final DateTime created_at;

  MusicModel({
    required this.id,
    required this.music_name,
    required this.artist_name,
    required this.music_url,
    required this.thumbnail_url,
    required this.hex_code,
    required this.created_at,
  });

  MusicModel copyWith({
    String? id,
    String? music_name,
    String? artist_name,
    String? music_url,
    String? thumbnail_url,
    String? hex_code,
    DateTime? created_at,
  }) {
    return MusicModel(
      id: id ?? this.id,
      music_name: music_name ?? this.music_name,
      artist_name: artist_name ?? this.artist_name,
      music_url: music_url ?? this.music_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      hex_code: hex_code ?? this.hex_code,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'music_name': music_name,
      'artist_name': artist_name,
      'music_url': music_url,
      'thumbnail_url': thumbnail_url,
      'hex_code': hex_code,
      'created_at': created_at.toIso8601String(),
    };
  }

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      id: map['id'] ?? '',
      music_name: map['music_name'] ?? '',
      artist_name: map['artist_name'] ?? '',
      music_url: map['music_url'] ?? '',
      thumbnail_url: map['thumbnail_url'] ?? '',
      hex_code: map['hex_code'] ?? '',
      created_at:
          DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicModel.fromJson(String source) =>
      MusicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MusicModel(id: $id, music_name: $music_name, artist_name: $artist_name, music_url: $music_url, thumbnail_url: $thumbnail_url, hex_code: $hex_code, created_at: $created_at)';
  }

  @override
  bool operator ==(covariant MusicModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.music_name == music_name &&
        other.artist_name == artist_name &&
        other.music_url == music_url &&
        other.thumbnail_url == thumbnail_url &&
        other.hex_code == hex_code &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        music_name.hashCode ^
        artist_name.hashCode ^
        music_url.hashCode ^
        thumbnail_url.hashCode ^
        hex_code.hashCode ^
        created_at.hashCode;
  }
}
