


import 'package:bookgram/features/presentation/secondary_page/dettails_page/single_page_detail.dart';
import 'package:bookgram/features/presentation/secondary_page/all_books/all_books.dart';
import 'package:bookgram/features/presentation/secondary_page/conf_screen/config_screen.dart';
import 'package:bookgram/features/presentation/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/app_entity.dart';
import 'package:bookgram/features/domain/entities/comment/comment_entity.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/replay/replay_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/presentation/page/credential/sign_in_page.dart';
import 'package:bookgram/features/presentation/page/credential/sign_up_page.dart';
import 'package:bookgram/features/presentation/secondary_page/dettails_page/comment_page.dart';
import 'package:bookgram/features/presentation/secondary_page/comment_page/edit_comment_page.dart';
import 'package:bookgram/features/presentation/secondary_page/comment_page/edit_replay_page.dart';
import 'package:bookgram/features/presentation/secondary_page/post_page/update_post_page.dart';
import 'package:bookgram/features/presentation/secondary_page/conf_screen/edit_profile_page.dart';
import 'package:bookgram/features/presentation/secondary_page/followers_page/followers_page.dart';
import 'package:bookgram/features/presentation/secondary_page/followers_page/following_page.dart';
import 'package:bookgram/features/presentation/secondary_page/user_page/single_user_profile_page.dart';

import '../features/presentation/secondary_page/post_page/post_detail_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case PageConst.editProfilePage: {
        if (args is UserEntity) {
          return routeBuilder(EditProfilePage(currentUser: args,));

        } else {
          return routeBuilder(const NoPageFound());
        }

      }
      case PageConst.updatePostPage: {
        if (args is PostEntity) {
          return routeBuilder(UpdatePostPage(post: args,));

        } else {
          return routeBuilder(const NoPageFound());
        }
      }
      case PageConst.configScreen: {
        if (args is UserEntity) {
          return routeBuilder(ConfigScreen( currentUser: args,));

        } else {
          return routeBuilder(const NoPageFound());
        }
      }
      case PageConst.updateCommentPage: {
        if (args is CommentEntity) {
          return routeBuilder(EditCommentPage(comment: args,));

        } else {
          return routeBuilder(const NoPageFound());
        }
      }
      case PageConst.updateReplayPage: {
        if (args is ReplayEntity) {
          return routeBuilder(EditReplayPage(replay: args,));

        } else {
          return routeBuilder(const NoPageFound());
        }
      }

      case PageConst.allBooks: {

          return routeBuilder(const AllBooks());


      }
      case PageConst.commentPage: {
        if (args is AppEntity) {
          return routeBuilder(CommentPage(appEntity: args,));
        }
        return routeBuilder(const NoPageFound());
      }
      case PageConst.postDetailPage: {
        if (args is String) {
          return routeBuilder(PostDetailPage(postId: args,));
        }
        return routeBuilder(const NoPageFound());
      }
      case PageConst.singleUserProfilePage: {
        if (args is String) {
          return routeBuilder(SingleUserProfilePage(otherUserId: args,));
        }
        return routeBuilder(const NoPageFound());
      }
      case PageConst.singleDetailsPage: {
        if (args is AppEntity) {
          return routeBuilder(SingleDetailsPage(appEntity: args));
        }
        return routeBuilder(const NoPageFound());
      }
      case PageConst.followingPage: {
        if (args is UserEntity) {
          return routeBuilder(FollowingPage(user: args,));
        }
        return routeBuilder(const NoPageFound());
      }
      case PageConst.followersPage: {
        if (args is UserEntity) {
          return routeBuilder(FollowersPage(user: args,));
        }
        return routeBuilder(const NoPageFound());
      }
      case PageConst.signInPage: {
        return routeBuilder(const SignInPage());
      }
      case PageConst.signUpPage: {
        return routeBuilder(const SignUpPage());
      }
      default: {
        const NoPageFound();
      }
    }
    return null;
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Erro"), 
      body: const Center(child: Text("Pagina nao encontrada"),),
    );
  }
}

