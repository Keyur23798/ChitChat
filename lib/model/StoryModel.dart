import 'package:firebase_database/firebase_database.dart';

class StoryModel {
  String? name;
  String? url;
  String? userId;

  StoryModel(
      {this.name,
        this.url,
        this.userId,
      });

  StoryModel.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        url = json['url'] as String,
        userId = json['userId'] as String;

  StoryModel.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value['name'] as String,
        url = snapshot.value['url'] as String,
        userId = snapshot.value['userId'] as String;

  toJson() {
    return {
      "name": name,
      "url": url,
      "userId": userId,
    };
  }
}