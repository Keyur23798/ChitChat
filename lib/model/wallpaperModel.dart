import 'package:firebase_database/firebase_database.dart';

class WallpaperModel {
  String? url;

  WallpaperModel(
      {this.url,
      });

  WallpaperModel.fromJson(Map<dynamic, dynamic> json)
      : url = json['url'] as String;

  WallpaperModel.fromSnapshot(DataSnapshot snapshot)
      : url = snapshot.value['url'] as String;

  toJson() {
    return {
      "url": url,
    };
  }
}