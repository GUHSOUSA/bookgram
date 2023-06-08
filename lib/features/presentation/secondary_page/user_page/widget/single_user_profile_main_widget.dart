
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:bookgram/features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:bookgram/features/presentation/cubit/user/user_cubit.dart';
import 'package:bookgram/constants/profile_widget.dart';
import 'package:bookgram/constants/injection_container.dart' as di;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/entities/app_entity.dart';
import '../../../widgets/common_widget.dart';
class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;
  const SingleUserProfileMainWidget({Key? key, required this.otherUserId}) : super(key: key);

  @override
  State<SingleUserProfileMainWidget> createState() => _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState extends State<SingleUserProfileMainWidget> {
  String _currentUid = "";

  @override
  void initState() {
    BlocProvider.of<GetSingleOtherUserCubit>(context).getSingleOtherUser(otherUid: widget.otherUserId);
    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());
    super.initState();

    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleOtherUserCubit, GetSingleOtherUserState>(
      builder: (context, userState) {
        if (userState is GetSingleOtherUserLoaded) {
          final singleUser = userState.otherUser;
          return Scaffold(
              backgroundColor: AppColors.primaryBackground,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: AppColors.primaryText),
                elevation: 0.2,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: resusableMenuText("${singleUser.username}"),
                actions: [
                  _currentUid == singleUser.uid ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageConst.configScreen,
                              arguments: singleUser);}, child: const Icon(Icons.menu, color: primaryColor,)),
                  ) : Container()
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15.h),
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child:
                          profileWidget(imageUrl: singleUser.profileUrl
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            resusableMenuText("@${singleUser
                                .username}"),
                            const Icon(Icons.qr_code)
                          ]),
                      sizeVer(20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [

                                Text(
                                  "${singleUser.totalPosts}",
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                resusableMenuText("Livros",
                                    color: AppColors.primaryThreeElementText,
                                    fontWeight: FontWeight.w400),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              height: 15,
                              width: 0.2,
                              color: Colors.black,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageConst.followersPage,
                                    arguments: singleUser);
                              },
                              child: GestureDetector(
                                child: Column(
                                  children: [

                                    Text(
                                      "${singleUser.totalFollowers}",
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    resusableMenuText("Seguidores",
                                        color: AppColors
                                            .primaryThreeElementText,
                                        fontWeight: FontWeight.w400),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              height: 15,
                              width: 0.2,
                              color: Colors.black,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageConst.followingPage,
                                    arguments: singleUser);
                              },
                              child: Column(
                                children: [

                                  Text(
                                    "${singleUser.totalFollowing}",
                                    style: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  resusableMenuText("Seguindo",
                                      color: AppColors.primaryThreeElementText,
                                      fontWeight: FontWeight.w400),

                                ],
                              ),
                            ),

                          ]

                      ),
                      sizeVer(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [


                          SizedBox(width: 5.w,),
                _currentUid == singleUser.uid ? Container() :buttonPerfilWidget(
                    singleUser.followers!.contains(_currentUid) ?"Sequindo":"Seguir",
                    16,
                    "true",
                     () {
              BlocProvider.of<UserCubit>(context).followUnFollowUser(
              user: UserEntity(
              uid: _currentUid,
              otherUid: widget.otherUserId
              )
              );
              },
                          ),

                        ],


                      ),
                      sizeVer(10),
                      buttonPerfilWidget("${singleUser.bio}", 10, "false",(){}),

                      sizeVer(30),

                      Container(height: 0.3,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.5),),
                      BlocBuilder<PostCubit, PostState>(
                        builder: (context, postState) {
                          if (postState is PostLoaded) {
                            final posts = postState.posts.where((post) =>
                            post.creatorUid == widget.otherUserId).toList();
                            return GridView.builder(
                                itemCount: posts.length,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: _currentUid, postId: posts[index].postId));
                                      },
                                    child: Center(
                                      child: SizedBox(
                                        height: 180,
                                        width: 150,

                                        child: Stack(
                                            children: [
                                              Positioned(
                                                  bottom: 0,
                                                  child: Container(

                                                    width: 150,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: const Color(
                                                          0xffcaeff7,)

                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        const Positioned(
                                                            right: 10,
                                                            top: 10,
                                                            child: Icon(Icons.favorite)),
                                                        Positioned(
                                                          bottom: 5,
                                                          left: 15,
                                                          right: 15,
                                                          child: Column(
                                                            children: [
                                                              resusableMenuText("${posts[index].title}", fontSize: 12),
                                                              resusableMenuText("${posts[index].author}", fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal)
                                                            ],

                                                          ),)
                                                      ],

                                                    ),
                                                  )),
                                              Positioned(
                                                  bottom: 50,
                                                  left: 15,


                                                  child: Row(
                                                    children: [
                                                      Container(height: 140, width: 5, color: Colors.white),
                                                      SizedBox(height: 140,child: profileWidget(imageUrl: posts[index].postImageUrl)
                                                      ),
                                                    ],
                                                  ))

                                            ]
                                        ),
                                      ),
                                    )
                                  );
                                });
                          }
                          return const Center(child: CircularProgressIndicator(),);
                        },
                      )
                    ],
                  ),
                ),
              )
          );
        }
        return const Center(child: CircularProgressIndicator(),);

});}


        }




