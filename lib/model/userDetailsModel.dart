import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? dateTime;
  String? lastMessage;
  String? online;
  String? about;
  String? fullName;
  bool? hasStory;
  bool? isVerifiedOtp;
  String? mobileNo;
  String? pendingMessage;
  String? photoUrl;
  String? userId;

  UserModel(
      {this.dateTime,
      this.lastMessage,
      this.online,
      this.about,
      this.fullName,
      this.hasStory,
      this.isVerifiedOtp,
      this.mobileNo,
      this.pendingMessage,
      this.photoUrl,
      this.userId,
      });

  UserModel.fromJson(Map<dynamic, dynamic> json)
      : dateTime = json['DateTime'] as String,
        lastMessage = json['LastMessage'] as String,
        online = json['Online'] as String,
        about = json['about'] as String,
        fullName = json['fullName'] as String,
        hasStory = json['hasStory'] as bool,
        isVerifiedOtp = json['isVerifiedOtp'] as bool,
        mobileNo = json['mobileNo'] as String,
        pendingMessage = json['pendingMessage'] as String,
        photoUrl = json['photoUrl'] as String,
        userId = json['userId'] as String;

  UserModel.fromSnapshot(DataSnapshot snapshot)
      : dateTime = snapshot.value['DateTime'] as String,
        lastMessage = snapshot.value['LastMessage'] as String,
        online = snapshot.value['Online'] as String,
        about = snapshot.value['about'] as String,
        fullName = snapshot.value['fullName'] as String,
        hasStory = snapshot.value['hasStory'] as bool,
        isVerifiedOtp = snapshot.value['isVerifiedOtp'] as bool,
        mobileNo = snapshot.value['mobileNo'] as String,
        pendingMessage = snapshot.value['pendingMessage'] as String,
        photoUrl = snapshot.value['photoUrl'] as String,
        userId = snapshot.value['userId'] as String;

  toJson() {
    return {
      "DateTime": dateTime,
      "LastMessage": lastMessage,
      "Online": online,
      "about": about,
      "fullName": fullName,
      "hasStory": hasStory,
      "isVerifiedOtp": isVerifiedOtp,
      "mobileNo": mobileNo,
      "pendingMessage": pendingMessage,
      "photoUrl": photoUrl,
      "userId": userId,
    };
  }
}