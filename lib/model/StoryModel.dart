import 'package:firebase_database/firebase_database.dart';

class StoryModel {
  String? name;
  String? url;
  String? userId;
  String? time;

  StoryModel(
      {this.name,
        this.url,
        this.userId,
        this.time,
      });

  StoryModel.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        url = json['url'] as String,
        userId = json['userId'] as String,
        time = json['time'] as String;

  StoryModel.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value['name'] as String,
        url = snapshot.value['url'] as String,
        userId = snapshot.value['userId'] as String,
        time = snapshot.value['time'] as String;

  toJson() {
    return {
      "name": name,
      "url": url,
      "userId": userId,
      "time":time,
    };
  }
}