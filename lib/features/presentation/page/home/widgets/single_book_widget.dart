
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/presentation/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/app_entity.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:bookgram/constants/profile_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookgram/constants/injection_container.dart'as di;

import '../../../cubit/user/user_cubit.dart';

class SingleBookWidget extends StatefulWidget {
  final PostEntity post;
  const SingleBookWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<SingleBookWidget> createState() => _SingleBookWidgetState();
}

class _SingleBookWidgetState extends State<SingleBookWidget> {

  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

    Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: _currentUid, postId: widget.post.postId));
      },
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 125.h,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [

                //imagem do item de pesquisar
                Container(
                  margin: EdgeInsets.only(right: 20.w),
                  height: 120.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,

                  ),
                  child: ClipRRect( borderRadius: BorderRadius.circular(10),
                      child: profileWidget(imageUrl: widget.post.postImageUrl)
                  ),
                ),
                //informaçoes do meio do item de pesquisar
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 150.w,
                              child: resusableMenuText("${widget.post.title}")),
                          Container(
                              margin: EdgeInsets.only(top: 8.h),
                              width: 100.w,
                              child: resusableText("${widget.post.author}")),

                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Row(

                          children: [
                            Icon(Icons.comment, color: AppColors.primaryThreeElementText, size: 17.w,),
                            SizedBox(width: 5.w,),
                            resusableMenuText("${widget.post.totalComments}", color: AppColors.primaryThreeElementText, fontSize: 14),

                          ],
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
            //final
            Container(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    children: [
                      GestureDetector(onTap: _likePost,child: Icon(widget.post.likes!.contains(_currentUid)?Icons.favorite : Icons.favorite_outline, color: widget.post.likes!.contains(_currentUid)? Colors.red : Colors.black.withOpacity(0.5),size: 22,),),
                      resusableMenuText("${widget.post.totalLikes}", fontSize: 13, color: AppColors.primaryThreeElementText, fontWeight: FontWeight.normal)
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.star_outline_sharp, color: Colors.yellow, size: 17.w,),
                      resusableMenuText("4.9", fontSize: 13, color: AppColors.primaryThreeElementText, fontWeight: FontWeight.normal)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    );


  }
  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(post: PostEntity(
      postId: widget.post.postId
    )
    );}
}
