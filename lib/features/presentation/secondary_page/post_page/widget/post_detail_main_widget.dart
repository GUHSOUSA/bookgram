import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:bookgram/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookgram/constants/injection_container.dart' as di;

import '../../../cubit/comment/comment_cubit.dart';
import '../../../cubit/replay/replay_cubit.dart';
import '../../../cubit/user/get_single_user/get_single_user_cubit.dart';
import '../../../widgets/common_widget.dart';
import '../../reading_page/reading.dart';
import '../../comment_page/widgets/single_comment_widget.dart';
class PostDetailMainWidget extends StatefulWidget {
  final String postId;
  const PostDetailMainWidget({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {

  String _currentUid = "";

  @override
  void initState() {

    BlocProvider.of<GetSinglePostCubit>(context).getSinglePost(postId: widget.postId);

    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  final bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: backGroundColor,
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
        builder: (context, getSinglePostState) {
          if (getSinglePostState is GetSinglePostLoaded) {
            final singlePost = getSinglePostState.post;
            return SizedBox(
              height: double.infinity,
              width: double.infinity,

              child: Stack(

                children: [
                  Positioned(
                      left: 0,
                      right: 0,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
                        child: Container(
                          height: 300.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage("${singlePost.postImageUrl}"),
                                  fit: BoxFit.cover)
                          ),
                        ),
                      )),

                  Positioned(
                      left: 10.w,
                      top: 20.h,
                      child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back,color: Colors.white,))),

                  Positioned(
                    top: 250.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.only(topRight: Radius.circular(30.w), topLeft: Radius.circular(30.w)),
                        color: Colors.white,
                      ),
                      height: 510.h,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 40.h, left: 15.w),
                              child:
                              SizedBox(
                                  width: 220,
                                  child: resusableMenuText("${singlePost.title}")),


                            ),
                            Container(
                                margin: EdgeInsets.only(left: 15.w, top: 15.h),
                                child: resusableMenuText("Autor: ${singlePost.author}", fontWeight: FontWeight.w800, color: AppColors.primaryThreeElementText)),
                            Container(
                              margin: EdgeInsets.only(top:5.h, left: 15.w, right: 15.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  resusableText("Enviado por: ${singlePost.username}"),
                                  Column(
                                    children: [
                                      Icon(Icons.bookmark_outline, size: 30.w, ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15.w, top:15.h, bottom: 15.h),
                              child: Row(
                                children: [
                                  Icon(Icons.favorite, size: 20.w,color: Colors.black.withOpacity(0.5)),
                                  resusableMenuText("${singlePost.totalLikes}", fontSize: 16,),
                                  SizedBox(width: 10.w,),

                                  Icon(Icons.comment, size: 20,color: Colors.black.withOpacity(0.5)),
                                  resusableMenuText("${singlePost.totalComments}"),
                                  SizedBox(width: 10.w,),
                                  const Icon(Icons.star, size: 20, color: Colors.yellowAccent,),
                                  resusableMenuText("0")
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.grey,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 15.h, left: 15.w),
                                width: double.infinity,
                                child:  Center(child: resusableMenuText("Comentarios ${singlePost.totalComments}"))),
                      BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
                        builder: (context, singleUserState) {
                          if (singleUserState is GetSingleUserLoaded) {
                            final singleUser = singleUserState.user;
                            return BlocBuilder<CommentCubit, CommentState>(
                        builder: (context, commentState) {
                          if (commentState is CommentLoaded) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: commentState.comments.length,
                                itemBuilder: (context, index) {
                                  final singleComment =
                                  commentState.comments[index];
                                  return BlocProvider(
                                    create: (context) => di.sl<ReplayCubit>(),
                                    child: SingleCommentWidget(
                                      currentUser: singleUser,
                                      comment: singleComment,

                                    )
                                  );
                                });
                          }return const Center(child: CircularProgressIndicator());});
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                          ],
                        ),
                      ),


                    ),
                  ),
                  Positioned(
                    right: 30.w,
                    top: 235,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadPdf(pdfUrl: '${singlePost.postPdfUrl}',),
                          ),
                        );
                      },
                      child: Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryElement,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),



                ],
              ),
            );

          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }



  _deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(post: PostEntity(postId: widget.postId));
  }

}
