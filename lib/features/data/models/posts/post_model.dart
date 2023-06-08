
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';

class PostModel extends PostEntity {

  final String? postId;
  final String? creatorUid;
  final String? username;
  final String? title;
  final String? author;
  final String? postPdfUrl;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;


  PostModel({this.title, this.author, this.postPdfUrl,
    this.postId,
    this.creatorUid,
    this.username,
    this.description,
    this.postImageUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  }) : super(
    createAt: createAt,
    creatorUid: creatorUid,
    description: description,
    title: title,
    author: author,
    postPdfUrl: postPdfUrl,
    likes: likes,
    postId: postId,
    postImageUrl: postImageUrl,
    totalComments: totalComments,
    totalLikes: totalLikes,
    username: username,
    userProfileUrl: userProfileUrl,
  );

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      createAt: snapshot['createAt'],
      creatorUid: snapshot['creatorUid'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      postImageUrl: snapshot['postImageUrl'],
      postId: snapshot['postId'],
      username: snapshot['username'],
      likes: List.from(snap.get("likes")),
      title: snapshot['title'],
      author: snapshot['author'],
      postPdfUrl: snapshot['postPdfUrl']
    );
  }

  Map<String, dynamic> toJson() => {
    "createAt": createAt,
    "creatorUid": creatorUid,
    "description": description,
    "userProfileUrl": userProfileUrl,
    "totalLikes": totalLikes,
    "totalComments": totalComments,
    "postImageUrl": postImageUrl,
    "postId": postId,
    "likes": likes,
    "username": username,
    "title": title,
    "author": author,
    "postPdfUrl": postPdfUrl
  };
}