
import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? username;
  final String? name;
  final String? bio;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;
  final List? read;
  final num? totalRead;
  final List? reading;
final num? totalReading;
final List? likes;
final num? totalLikes;
final num? totalWords;

  // will not going to store in DB
  final File? imageFile;
  final String? password;
  final String? otherUid;

  UserEntity({
    this.imageFile,
    this.uid,
    this.username,
    this.name,
    this.bio,
    this.website,
    this.email,
    this.profileUrl,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
    this.password,
    this.otherUid,
    this.totalPosts,
    this.read,
    this.totalRead,
    this.reading,
    this.totalReading,
    this.likes,
    this.totalLikes,
    this.totalWords

  });

  @override
  List<Object?> get props => [
    uid,
    username,
    name,
    bio,
    website,
    email,
    profileUrl,
    followers,
    following,
    totalFollowers,
    totalFollowing,
    password,
    otherUid,
    totalPosts,
    imageFile,
    read,
    totalRead,
    reading,
    totalReading,
    likes,
    totalLikes,
    totalWords
  ];
}
