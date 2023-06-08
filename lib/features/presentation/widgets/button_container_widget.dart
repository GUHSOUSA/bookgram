
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/consts.dart';


class ButtonContainerWidget extends StatelessWidget {
  final String? color;
  final String? text;
  final VoidCallback? onTapListener;
  const ButtonContainerWidget({Key? key, this.color, this.text, this.onTapListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
      width: 325.w,
      height: 50.h,
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: color=="login"?25.h: 20.h),
      decoration: BoxDecoration(

        color: color=="login"?AppColors.primaryElement:AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(15.w),
          border: Border.all(
            color: color=="login"?Colors.transparent:AppColors.primaryFourElementText
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
              color: Colors.grey.withOpacity(0.1)
            )
          ]
      ),
      child: Center(
        child: Text(
          text.toString(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
            color: color=="login"?AppColors.primaryBackground: AppColors.primaryText
          ),
        ),
      ),
    ),
   );
  }
}
