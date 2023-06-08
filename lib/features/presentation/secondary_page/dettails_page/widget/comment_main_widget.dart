import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/constants/profile_widget.dart';
import 'package:bookgram/constants/injection_container.dart' as di;
import 'package:bookgram/features/domain/entities/app_entity.dart';
import 'package:bookgram/features/domain/entities/comment/comment_entity.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:bookgram/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:bookgram/features/presentation/cubit/replay/replay_cubit.dart';
import 'package:bookgram/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:bookgram/features/presentation/cubit/user/user_cubit.dart';
import 'package:bookgram/features/presentation/secondary_page/comment_page/widgets/single_comment_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/common_widget.dart';
import '../../reading_page/reading.dart';

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;

  const CommentMainWidget({Key? key, required this.appEntity})
      : super(key: key);

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  int selectedIndex = 0;


  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);

    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.appEntity.postId!);

    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);

    super.initState();
  }

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar("detalhes"), body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, singleUserState) {
        if (singleUserState is GetSingleUserLoaded) {
          final singleUser = singleUserState.user;
          return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
            builder: (context, singlePostState) {
              if (singlePostState is GetSinglePostLoaded) {
                final singlePost = singlePostState.post;
                return BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, commentState) {
                    if (commentState is CommentLoaded) {
                      return Scaffold(
                        body: SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 30.h, right: 15.w, left: 15.w),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 250.h,
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.w),
                                            child: profileWidget(
                                                imageUrl:
                                                    singlePost.postImageUrl),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      SizedBox(
                                        child: resusableMenuText(
                                            '${singlePost.title}'),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      resusableText("${singlePost.author}"),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      SizedBox(
                                        height: 80.h,
                                        width: 250.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: const Color(
                                                          0xffffd700),
                                                      size: 15.w,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    resusableMenuText("0.0",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  ],
                                                ),
                                                resusableMenuText('Avaliações',
                                                    color: AppColors
                                                        .primaryThreeElementText,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .panorama_horizontal_select,
                                                      color: Colors.blue,
                                                      size: 15.w,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    resusableMenuText("247",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  ],
                                                ),
                                                resusableMenuText('Páginas',
                                                    color: AppColors
                                                        .primaryThreeElementText,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.language,
                                                      color: Colors.green,
                                                      size: 15.w,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    resusableMenuText("Brasil",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  ],
                                                ),
                                                resusableMenuText('Pais',
                                                    color: AppColors
                                                        .primaryThreeElementText,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = 0;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: selectedIndex ==
                                                                0
                                                            ? Colors.blue
                                                            : Colors
                                                                .transparent,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Descrição',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = 1;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: selectedIndex ==
                                                                1
                                                            ? Colors.blue
                                                            : Colors
                                                                .transparent,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Comentários',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = 2;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: selectedIndex ==
                                                                2
                                                            ? Colors.blue
                                                            : Colors
                                                                .transparent,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Similar',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          selectedIndex == 0
                                              ? const SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      // Conteúdo para Comentários
                                                    ],
                                                  ),
                                                )
                                              : selectedIndex == 1
                                                  ? SingleChildScrollView(
                                                      child: Column(
                                                        children: [

                                                          // Conteúdo para Descrição
                                                          ListView.builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  commentState
                                                                      .comments
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final singleComment =
                                                                    commentState
                                                                            .comments[
                                                                        index];
                                                                return BlocProvider(
                                                                  create: (context) =>
                                                                      di.sl<
                                                                          ReplayCubit>(),
                                                                  child:
                                                                      SingleCommentWidget(
                                                                    currentUser:
                                                                        singleUser,
                                                                    comment:
                                                                        singleComment,
                                                                    onLongPressListener:
                                                                        () {
                                                                      _openBottomModalSheet(
                                                                        context:
                                                                            context,
                                                                        comment:
                                                                            commentState.comments[index],
                                                                      );
                                                                    },
                                                                    onLikeClickListener:
                                                                        () {
                                                                      _likeComment(
                                                                          comment:
                                                                              commentState.comments[index]);
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                        ],
                                                      ),
                                                    )
                                                  : const SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          // Conteúdo para Similar
                                                          Text(
                                                              'Conteúdo dos Similar'),
                                                        ],
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        floatingActionButton: selectedIndex == 0
                            ? Container(
                                margin: EdgeInsets.only(
                                    left: 40.w, right: 10.w, bottom: 10.h),
                                height: 55.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 55.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.w),
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<UserCubit>(context)
                                                .readingOrNotUses(
                                                    user: UserEntity(
                                                        uid: singleUser.uid),
                                                    post: PostEntity(
                                                        postId:
                                                            singlePost.postId));
                                          },
                                          icon: Icon(
                                            singleUser.reading!
                                                    .contains(singlePost.postId)
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                            size: 30.w,
                                            color: singleUser.reading!
                                                    .contains(singlePost.postId)
                                                ? AppColors.primaryElement
                                                : AppColors
                                                    .primaryThreeElementText,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReadPdf(
                                              pdfUrl:
                                                  '${singlePost.postPdfUrl}',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 55.h,
                                        width: 250.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                          color: AppColors.primaryElement,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            resusableMenuText("Ler livro",
                                                color: Colors.white),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            resusableMenuText(">>>",
                                                color: Colors.white)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                            : selectedIndex == 1
                                ? Container(
                          height: 40.h,
                          width: 160.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.w),
                            color: Colors.black
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                resusableMenuText("Add comentario", color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal ),
                                SizedBox(width: 5.w,),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                                  height: 34.h,
                                  width: 34.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.w),
                                      color: Colors.white
                                  ),
                                  child: Icon(Icons.comment, size: 16.w,),
                                ),
                              ],
                            ),
                          ),
                        )
                                : const SizedBox(),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    )
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: currentUser.profileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
                child: TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: primaryColor),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Post your comment...",
                  hintStyle: TextStyle(color: secondaryColor)),
            )),
            GestureDetector(
                onTap: () {
                  _createComment(currentUser);
                },
                child: const Text(
                  "Post",
                  style: TextStyle(fontSize: 15, color: blueColor),
                ))
          ],
        ),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
            comment: CommentEntity(
      totalReplays: 0,
      commentId: const Uuid().v1(),
      createAt: Timestamp.now(),
      likes: const [],
      username: currentUser.username,
      userProfileUrl: currentUser.profileUrl,
      description: _descriptionController.text,
      creatorUid: currentUser.uid,
      postId: widget.appEntity.postId,
    ))
        .then((value) {
      setState(() {
        _descriptionController.clear();
      });
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required CommentEntity comment}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "More Options",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: primaryColor),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _deleteComment(
                              commentId: comment.commentId!,
                              postId: comment.postId!);
                        },
                        child: const Text(
                          "Delete Comment",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                    const Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    sizeVer(7),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, PageConst.updateCommentPage,
                              arguments: comment);

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));
                        },
                        child: const Text(
                          "Update Comment",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _deleteComment({required String commentId, required String postId}) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
        comment: CommentEntity(commentId: commentId, postId: postId));
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
        comment: CommentEntity(
            commentId: comment.commentId, postId: comment.postId));
  }
}
