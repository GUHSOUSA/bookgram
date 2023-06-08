
import 'dart:io';

import 'package:bookgram/features/presentation/widgets/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:bookgram/features/data/models/comment/comment_model.dart';
import 'package:bookgram/features/data/models/posts/post_model.dart';
import 'package:bookgram/features/data/models/replay/replay_model.dart';
import 'package:bookgram/features/data/models/user/user_model.dart';
import 'package:bookgram/features/domain/entities/comment/comment_entity.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/replay/replay_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:uuid/uuid.dart';


class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  FirebaseRemoteDataSourceImpl(
      {required this.firebaseStorage, required this.firebaseFirestore, required this.firebaseAuth});

  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
          uid: uid,
          name: user.name,
          email: user.email,
          bio: user.bio,
          following: user.following,
          website: user.website,
          profileUrl: profileUrl,
          username: user.username,
          totalFollowers: user.totalFollowers,
          followers: user.followers,
          totalFollowing: user.totalFollowing,
          totalPosts: user.totalPosts,
          read: user.read,
          totalRead: user.totalRead,
          reading: user.reading,
          totalReading: user.totalReading,
          likes: user.likes,
          totalLikes: user.totalLikes,
          totalWords: user.totalWords


      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toastInfo(msg: "Algum erro ocorreu");
    });
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
          uid: uid,
          name: user.name,
          email: user.email,
          bio: user.bio,
          following: user.following,
          website: user.website,
          profileUrl: user.profileUrl,
          username: user.username,
          totalFollowers: user.totalFollowers,
          followers: user.followers,
          totalFollowing: user.totalFollowing,
          totalPosts: user.totalPosts,
          read: user.read,
          totalRead: user.totalRead,
          reading: user.reading,
          totalReading: user.totalReading,
          likes: user.likes,
          totalLikes: user.totalLikes,
          totalWords: user.totalWords
      ).toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toastInfo(msg: "Algum erro ocorreu");
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;


  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity user) async {
    if (user.email!.isEmpty) {
      toastInfo(msg: "Por favor, digite seu email");
    }
    if (user.password!.isEmpty) {
      toastInfo(msg: "Por favor, digite uma senha");
    }
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toastInfo(msg: "usuario não encontrado");
      } else if (e.code == 'wrong-password') {
        toastInfo(msg: "senha incorreta");
      } else if (e.code == 'invalid-email') {
        toastInfo(msg: "o formato de email está incorreto");
      }
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> signUpUser(UserEntity user) async {
    if (user.email!.isEmpty) {
      toastInfo(msg: "Por favor, digite um email.");
    }
    if (user.username!.isEmpty) {
      toastInfo(msg: "Por favor, digite um usuario.");
    }
    if (user.password!.isEmpty) {
      toastInfo(msg: "Por favor, digite uma senha.");
    }
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!).then((
          currentUser) async {
        if (currentUser.user?.uid != null) {
          if (user.imageFile != null) {
            uploadImageToStorage(user.imageFile, false, "profileImages").then((
                profileUrl) {
              createUserWithImage(user, profileUrl);
            });
          } else {
            createUserWithImage(user, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        toastInfo(msg: "Por favor, digite uma senha mais forte.");
      } else if (err.code == 'email-already-in-use') {
        toastInfo(msg: "Esse email já está em uso.");
      } else if (err.code == 'invalid-email') {
        toastInfo(msg: "Por favor, digite um email válido.");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = {};

    if (user.username != "" && user.username != null) {
      userInformation['username'] = user.username;
    }

    if (user.website != "" && user.website != null) {
      userInformation['website'] = user.website;
    }

    if (user.profileUrl != "" && user.profileUrl != null) {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;

    if (user.name != "" && user.name != null) {
      userInformation['name'] = user.name;
    }

    if (user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }

    if (user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }

    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }


    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageToStorage(File? file, bool isPost,
      String childName) async {
    Reference ref = firebaseStorage.ref().child(childName).child(
        firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl = (await uploadTask.whenComplete(() {})).ref
        .getDownloadURL();

    return await imageUrl;
  }

  @override
  Future<String> upLoadPdfToFirebase(PlatformFile? platformFile, bool isPost,
      String childName) async {
    if (platformFile == null) {
      // Handle the case when the platformFile is null
      return '';
    }

    Reference ref = firebaseStorage.ref().child(childName).child(
        firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    File file = File(platformFile.path!);

    final uploadTask = ref.putFile(file);


    final pdfUrl = (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await pdfUrl;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final newPost = PostModel(
        author: post.author,
        postPdfUrl: post.postPdfUrl,
        title: post.title,
        userProfileUrl: post.userProfileUrl,
        username: post.username,
        totalLikes: 0,
        totalComments: 0,
        postImageUrl: post.postImageUrl,
        postId: post.postId,
        likes: const [],
        description: post.description,
        creatorUid: post.creatorUid,
        createAt: post.createAt
    ).toJson();

    try {
      final postDocRef = await postCollection.doc(post.postId).get();

      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore.collection(
              FirebaseConst.users).doc(post.creatorUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    } catch (e) {
      print("some error occured $e");
    }

  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    try {
      postCollection.doc(post.postId).delete().then((value) {
        final userCollection = firebaseFirestore.collection(FirebaseConst.users)
            .doc(post.creatorUid);

        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get('totalPosts');
            userCollection.update({"totalPosts": totalPosts - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);

    final currentUid = await getCurrentUid();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .orderBy("createAt", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    Map<String, dynamic> postInfo = Map();

    if (post.author != "" && post.description != null)
      postInfo['author'] = post.author;
    if (post.title != "" && post.description != null)
      postInfo['title'] = post.title;
    if (post.postImageUrl != "" && post.postImageUrl != null)
      postInfo['postImageUrl'] = post.postImageUrl;
    if (post.postPdfUrl != "" && post.postPdfUrl != null)
      postInfo['postPdfUrl'] = post.postPdfUrl;

    postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    final newComment = CommentModel(
        userProfileUrl: comment.userProfileUrl,
        username: comment.username,
        totalReplays: comment.totalReplays,
        commentId: comment.commentId,
        postId: comment.postId,
        likes: [],
        description: comment.description,
        creatorUid: comment.creatorUid,
        createAt: comment.createAt
    ).toJson();

    try {
      final commentDocRef = await commentCollection.doc(comment.commentId)
          .get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {
          final postCollection = firebaseFirestore.collection(
              FirebaseConst.posts).doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore.collection(FirebaseConst.posts)
            .doc(comment.postId);

        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);
    final currentUid = await getCurrentUid();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(postId).collection(FirebaseConst.comment)
        .orderBy("createAt", descending: true);
    return commentCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(comment.postId)
        .collection(FirebaseConst.comment);

    Map<String, dynamic> commentInfo = Map();

    if (comment.description != "" && comment.description != null)
      commentInfo["description"] = comment.description;

    commentCollection.doc(comment.commentId).update(commentInfo);
  }

  @override
  Future<void> createReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(replay.postId).collection(FirebaseConst.comment).doc(
        replay.commentId)
        .collection(FirebaseConst.replay);

    final newReplay = ReplayModel(
        userProfileUrl: replay.userProfileUrl,
        username: replay.username,
        replayId: replay.replayId,
        commentId: replay.commentId,
        postId: replay.postId,
        likes: [],
        description: replay.description,
        creatorUid: replay.creatorUid,
        createAt: replay.createAt
    ).toJson();


    try {
      final replayDocRef = await replayCollection.doc(replay.replayId).get();

      if (!replayDocRef.exists) {
        replayCollection.doc(replay.replayId).set(newReplay).then((value) {
          final commentCollection = firebaseFirestore.collection(
              FirebaseConst.posts).doc(replay.postId).collection(
              FirebaseConst.comment).doc(replay.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplays = value.get('totalReplays');
              commentCollection.update({"totalReplays": totalReplays + 1});
              return;
            }
          });
        });
      } else {
        replayCollection.doc(replay.replayId).update(newReplay);
      }
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(replay.postId).collection(FirebaseConst.comment).doc(
        replay.commentId)
        .collection(FirebaseConst.replay);

    try {
      replayCollection.doc(replay.replayId).delete().then((value) {
        final commentCollection = firebaseFirestore.collection(
            FirebaseConst.posts).doc(replay.postId).collection(
            FirebaseConst.comment).doc(replay.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplays = value.get('totalReplays');
            commentCollection.update({"totalReplays": totalReplays - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(replay.postId).collection(FirebaseConst.comment).doc(
        replay.commentId)
        .collection(FirebaseConst.replay);

    final currentUid = await getCurrentUid();

    final replayRef = await replayCollection.doc(replay.replayId).get();

    if (replayRef.exists) {
      List likes = replayRef.get("likes");
      if (likes.contains(currentUid)) {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(replay.postId).collection(FirebaseConst.comment).doc(
        replay.commentId)
        .collection(FirebaseConst.replay);
    return replayCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ReplayModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) async {
    final replayCollection = firebaseFirestore.collection(FirebaseConst.posts)
        .doc(replay.postId).collection(FirebaseConst.comment).doc(
        replay.commentId)
        .collection(FirebaseConst.replay);

    Map<String, dynamic> replayInfo = Map();

    if (replay.description != "" && replay.description != null)
      replayInfo['description'] = replay.description;

    replayCollection.doc(replay.replayId).update(replayInfo);
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);

    final myDocRef = await userCollection.doc(user.uid).get();
    final otherUserDocRef = await userCollection.doc(user.otherUid).get();

    if (myDocRef.exists && otherUserDocRef.exists) {
      List myFollowingList = myDocRef.get("following");
      List otherUserFollowersList = otherUserDocRef.get("followers");

      // My Following List
      if (myFollowingList.contains(user.otherUid)) {
        userCollection.doc(user.uid).update(
            {"following": FieldValue.arrayRemove([user.otherUid])}).then((
            value) {
          final userCollection = firebaseFirestore.collection(
              FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.uid).update(
            {"following": FieldValue.arrayUnion([user.otherUid])}).then((
            value) {
          final userCollection = firebaseFirestore.collection(
              FirebaseConst.users).doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing + 1});
              return;
            }
          });
        });
      }

      // Other User Following List
      if (otherUserFollowersList.contains(user.uid)) {
        userCollection.doc(user.otherUid).update(
            {"followers": FieldValue.arrayRemove([user.uid])}).then((value) {
          final userCollection = firebaseFirestore.collection(
              FirebaseConst.users).doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.otherUid).update(
            {"followers": FieldValue.arrayUnion([user.uid])}).then((value) {
          final userCollection = firebaseFirestore.collection(
              FirebaseConst.users).doc(user.otherUid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers + 1});
              return;
            }
          });
        });
      }
    }
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users)
        .where("uid", isEqualTo: otherUid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
  @override
  // essa é o botão que salva o livro em continuar lendo quando começa a ler
  Future<void> readingOrNot(PostEntity post, UserEntity user) async {
    //pega informaçoes sobre a coleçao usuarios no firebase
    final userReading = firebaseFirestore.collection(FirebaseConst.users);
    //aqui eu pego o id do usuario pra entrar na suas coleçoes
      final myDocRef = await userReading.doc(user.uid).get();

        //aqui eu entro na lista de reading do usuario pra ve o que tem dentro dessa lista
        List<dynamic> myReadingList = myDocRef.get("reading");
          // aqui eu vejo se o id do livro que eu quero add esta dentro da lista reading
        if (myReadingList.contains(post.postId)) {
          // Se o ID da postagem já estiver na lista "reading" eu quero que ele remova
          userReading.doc(user.uid).update({
            //aqui ele encontra o valor e remove
            "reading": FieldValue.arrayRemove([post.postId])
          }).then((_) {
            //quando ele remove o id do meu livro da coleçao "reading" do usuario
            userReading.doc(user.uid).get().then((userDoc) {
              //eu quero que remova um numero do total de livros que estao sendo lidos pelo usuario.
              if (userDoc.exists) {
                // o numero vai sair da coleçao 'totalReading'
                int totalReading = userDoc.get('totalReading');
                userReading.doc(user.uid).update({"totalReading": totalReading - 1});
              }
            });
          });
        } else {
          // Se o ID da postagem não estiver na lista "reading"
          userReading.doc(user.uid).update({
            //se nao estiver eu quero que add o id a coleçao 'reading'
            "reading": FieldValue.arrayUnion([post.postId])
          }).then((_) {
            userReading.doc(user.uid).get().then((userDoc) {
              if (userDoc.exists) {
                //depoois adicioner mais 1 no tatal de livros que estao sendo lidos pelo usuario
                int totalReading = userDoc.get('totalReading');
                userReading.doc(user.uid).update({"totalReading": totalReading + 1});
              }
            });
          });


    }
  }

  }



