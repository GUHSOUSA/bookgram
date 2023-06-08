import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:bookgram/constants/profile_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/entities/app_entity.dart';
import '../../../widgets/common_widget.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserEntity currentUser;

  const ProfileMainWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.primaryText),
          elevation: 0.2,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: resusableMenuText("${widget.currentUser.username}"),

          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
      Navigator.pushNamed(
          context, PageConst.configScreen,
          arguments: widget.currentUser);},

                  child: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
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
                      profileWidget(imageUrl: widget.currentUser.profileUrl),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                resusableMenuText("@${widget.currentUser.username}"),
                const Icon(Icons.qr_code)
              ]),
              sizeVer(20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                  children: [
                    Text(
                      "${widget.currentUser.totalPosts}",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
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
                    Navigator.pushNamed(context, PageConst.followersPage,
                        arguments: widget.currentUser);
                  },
                  child: GestureDetector(
                    child: Column(
                      children: [
                        Text(
                          "${widget.currentUser.totalFollowers}",
                          style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        resusableMenuText("Seguidores",
                            color: AppColors.primaryThreeElementText,
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
                    Navigator.pushNamed(context, PageConst.followingPage,
                        arguments: widget.currentUser);
                  },
                  child: Column(
                    children: [
                      Text(
                        "${widget.currentUser.totalFollowing}",
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                      resusableMenuText("Seguindo",
                          color: AppColors.primaryThreeElementText,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
              ]),
              sizeVer(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, PageConst.editProfilePage,
                            arguments: widget.currentUser);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                      },
                      child:
                          buttonPerfilWidget("Editar perfil", 16, "true", () {
                        Navigator.pushNamed(
                            context, PageConst.editProfilePage,
                            arguments: widget.currentUser);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                      })),
                  SizedBox(
                    width: 5.w,
                  ),
                ],
              ),
              sizeVer(10),
              buttonPerfilWidget(
                  "${widget.currentUser.bio == "" ? "Add biografia" : widget.currentUser.bio}",
                  10,
                  "false", () {
                Navigator.pushNamed(context, PageConst.editProfilePage,
                    arguments: widget.currentUser);
              }),
              //"${singleUser.name == ""? singleUser.username : singleUser.name}", style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),

              sizeVer(30),

              Container(
                height: 0.3,
                width: double.infinity,
                color: Colors.black.withOpacity(0.5),
              ),
              BlocBuilder<PostCubit, PostState>(
                builder: (context, postState) {
                  if (postState is PostLoaded) {
                    final posts = postState.posts
                        .where((post) =>
                            post.creatorUid == widget.currentUser.uid)
                        .toList();
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
                                Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: widget.currentUser.uid, postId: posts[index].postId));
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
                                                    bottom: 7.h,
                                                    left: 5.w,
                                                    right: 5.w,
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
                                            bottom: 60.h,
                                            left: 15,


                                            child: Row(
                                              children: [
                                                Container(height: 115, width: 5, color: Colors.black, child: Center(child: Text("B O O K G R A M", style: TextStyle(color: Colors.white, fontSize: 8.w),)),),
                                                SizedBox(height: 115,child: profileWidget(imageUrl: posts[index].postImageUrl)
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ));
  }

}

