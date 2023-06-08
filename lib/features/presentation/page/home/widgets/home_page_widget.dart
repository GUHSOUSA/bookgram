import 'package:bookgram/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/profile_widget.dart';
import '../../../../domain/entities/posts/post_entity.dart';
import '../../../widgets/common_widget.dart';

Widget searchViewWidget(TextEditingController controller){
  return Row(

    children: [

      Container(
        width: 280.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(15.w),
            border: Border.all(color: AppColors.primaryFourElementText)
        ),
        child: Row(children: [
          Container(
            margin: EdgeInsets.only(left: 17.w),
            width: 16.w,
            height: 16.w,
            child: Image.asset("assets/icons/search.png", color: Colors.grey.withOpacity(0.9),),
          ),
          SizedBox(
            width: 240.w,
            height: 40.h,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(7, 5, 0, 5),
                hintText: "Pesquise por nomes",
                border:  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent
                    )
                ),
                enabledBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent
                    )
                ),
                disabledBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent
                    )
                ),
                focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent
                    )
                ),
                hintStyle: TextStyle(
                    color: AppColors.primarySecondaryElementText
                ),

              ),
              style: TextStyle(color: AppColors.primaryText,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.normal,
                  fontSize: 12.sp),
              autocorrect: false,
              obscureText: false,
            ),
          )
        ]),
      ),
      GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 5.w),
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primaryElement,
            borderRadius: BorderRadius.all(Radius.circular(13.w)),
            border: Border.all(color: AppColors.primaryElement),
          ),
          child: Icon(Icons.search, size: 25.w, color: Colors.white,),
        ),
      )
    ],
  );
}
Widget currentReadingWidget(BuildContext context, PostEntity post) {
  return Container(
      margin: EdgeInsets.only(right: 15.w, bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(6.0, 6.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Transform.scale(
            scale: 1.0,
            child: Stack(
              children: [
                SizedBox(
                  height: 280.h,
                  width: 180.w,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.6), BlendMode.darken),
                      child:
                      profileWidget(imageUrl: post.postImageUrl)),
                ),
                const Positioned.fill(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                Positioned(
                  bottom: 35,
                  left: 20,

                  child:
                  SizedBox(
                      height: 30.h,
                      width: 120.w,
                      child: resusableMenuText("${post.title}",
                          color: Colors.grey, fontSize: 12)),

                ),
                Positioned(
                    bottom: 25,
                    left: 20,
                    child: Container(
                      height: 2,
                      width: 100.w,
                      color: AppColors.primaryElement,
                    )),
              ],
            ),
          )));
}

