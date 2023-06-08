import 'package:bookgram/constants/consts.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar buildAppBar(String type){
  return AppBar(
            iconTheme: const IconThemeData(color: AppColors.primaryText),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: AppColors.primarySecondaryBackground,
                height: 1.0,
              ),
            ),
            title: Text(type, style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 16.sp,
              
              fontWeight: FontWeight.normal
            ),),
          );
}
Widget buildThirdPartLogin(BuildContext context){
  return Container(
    margin: EdgeInsets.only(top: 35.h, bottom: 20.h),
    padding: EdgeInsets.only(left: 45.w, right: 45.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _resusableIcons("google"),
          _resusableIcons("apple"),
          _resusableIcons("facebook"),
          
        ],
      ),
    
  );
}

Widget _resusableIcons(String iconName){
  return GestureDetector(
            onTap: () {
              
            },
            child: SizedBox(
              width: 30.w,
              height: 30.w,
              child: Image.asset("assets/icons/$iconName.png"),
            ),
          );
}

Widget resusableText(String text){

  return Container(
    margin: EdgeInsets.only(bottom: 5.h),
    child: Text(text, style: TextStyle(
      color: Colors.grey.withOpacity(0.5),
      fontWeight: FontWeight.normal,
      fontSize: 14.sp
    ),),
  );
}

Widget buildTextField(String text, String textType, String iconName, TextEditingController textEditingController, ){
  return Container(
    width: 325.w,
    height: 50.h,
    margin: EdgeInsets.only(bottom: 15.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8.w)),
      border: Border.all(color: AppColors.primaryFourElementText)
    ),
    child: Row(
      children: [
        Container(
          width: 16.w,
          margin: EdgeInsets.only(left: 17.w),
          height: 16.w,
          child: Image.asset("assets/icons/$iconName.png"),
        ),
        SizedBox(
          width: 270.w,
          height: 50.h,
          child: TextField(
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: text,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent
                )
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent
                )
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent
                )
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent
                )
              ),
              hintStyle: const TextStyle(
                color: AppColors.primarySecondaryElementText
              ),
              
            ),
            style: TextStyle(color: AppColors.primaryText,
            fontFamily: "Avenir",
            fontWeight: FontWeight.normal,
            fontSize: 12.sp),
            autocorrect: false,
            obscureText: textType=="password"? true:false,
          ),
          
          
        )
      ],
    )
  );
}

Widget forgotPassword(void Function()? func, String text){
  return Container(
    margin: EdgeInsets.only(left: 25.w),
    width: 260.w,
    height: 44.h,
    child: GestureDetector(
      onTap: 
        func,
      
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.primaryText,
          decoration: TextDecoration.underline,
          fontSize: 12.sp,
          decorationColor: AppColors.primaryText,
          
        ),
      ),
    ),
  );
}

Widget buildLogInAdnRegButton(String buttonName, String buttonType, void Function()? func){
  return GestureDetector(
    onTap: func,
    child: Container(
      width: 325.w,
      height: 50.h,
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: buttonType=="login"?25.h: 20.h),
      decoration: BoxDecoration(

        color: buttonType=="login"?AppColors.primaryElement:AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(
            color: buttonType=="login"?Colors.transparent:AppColors.primaryFourElementText
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
          buttonName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
            color: buttonType=="login"?AppColors.primaryBackground: AppColors.primaryText
          ),
        ),
      ),
    ),
  );
}

Widget sliderView(){
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: 20.h),
        width: 200.w,
        height: 260.h,
        child: PageView(
          children: [
          Container(
            width: 325.w,
            height: 160.h,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.h)),
              image: const DecorationImage(
                fit: BoxFit.fill,
              image: AssetImage("assets/icons/wal.png")
            ),
            )
          ),
          Container(
            width: 325.w,
            height: 160.h,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.h)),
              image: const DecorationImage(
                fit: BoxFit.fill,
              image: AssetImage("assets/icons/wal.png")
            ),
            )
          ),
          Container(
            width: 325.w,
            height: 160.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.h)),
              image: const DecorationImage(
                fit: BoxFit.fill,
              image: AssetImage("assets/icons/wal.png")
            ),
            )
          )
       
       
        
        ]),
      ),
      DotsIndicator(

        dotsCount: 3,
        position: 0,
        decorator: DotsDecorator(
          color: AppColors.primaryThreeElementText,
          activeColor: AppColors.primaryElement,
          size: const Size.square(5.0),
          activeSize: const Size(17.0, 5.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          )
        ),
      )    
    ],
  );
}

Widget menuText(void Function()?  func){
  return Column(
    children: [
      Container(
        width: 325.w,
        margin: EdgeInsets.only(top: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            resusableMenuText("Pesquise por filtros"),
            GestureDetector(
                onTap: func,
                child: resusableMenuText("Ver tudo", color: AppColors.primaryThreeElementText, fontSize: 10))
          ],
        ),
      ),
      Container(

        margin: EdgeInsets.only(top: 20.w),
        child: Row(
          children: [
            _resuableSubTitule("Popular", ),
          ],
        ),
      )
    ],
  );

}

Widget resusableMenuText(String text, {Color color=AppColors.primaryText, int fontSize = 16, FontWeight fontWeight=FontWeight.bold}){
  return Text(
    text ,style: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.sp
    ),
  );
}

Widget _resuableSubTitule(String text, {Color textColor = AppColors.primaryElementText, Color backgroundColor = AppColors.primaryElement}){
  return Container(
              margin: EdgeInsets.only(right: 20.w),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(7.w),
                border: Border.all(color: backgroundColor),),
            padding: EdgeInsets.only(
              left: 15.w, right: 15.w, top: 5.h, bottom: 5.h             ),
            
             child: resusableMenuText(text, color: textColor, fontWeight: FontWeight.normal, fontSize: 11),
             
            );
}

Widget buttonPerfilWidget (String text, int size, String type, void Function() func){
  return GestureDetector(
    onTap: func,
    child: Container(

      padding: EdgeInsets.symmetric( horizontal: type =="true"? 20.w: 7, vertical: type =="true"? 10.w: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(type =="true"? 5.w: 2),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: resusableMenuText(text, fontWeight: FontWeight.normal, fontSize: size)
    ),
  );
}