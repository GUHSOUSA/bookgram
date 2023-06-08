import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backGroundColor =  Color.fromARGB(255, 255, 255, 255);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Color.fromARGB(255, 0, 0, 0);
const secondaryColor = Colors.black;
const darkGreyColor =  Color.fromRGBO(97, 97, 97, 1);

Widget sizeVer(double height) {
  return SizedBox(height: height,);
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}

class PageConst {
  static const String allBooks = "allBooks";
  static const String configScreen = "ConfigScreen";
  static const String singleDetailsPage = "singleDetailsPage";
  static const String editProfilePage = "editProfilePage";
  static const String updatePostPage = "updatePostPage";
  static const String commentPage = "commentPage";
  static const String signInPage = "signInPage";
  static const String signUpPage = "signUpPage";
  static const String updateCommentPage = "updateCommentPage";
  static const String updateReplayPage = "updateReplayPage";
  static const String postDetailPage = "postDetailPage";
  static const String singleUserProfilePage = "singleUserProfilePage";
  static const String followingPage = "followingPage";
  static const String followersPage = "followersPage";
}

class FirebaseConst {
  static const String users = "users";
  static const String posts = "posts";
  static const String comment = "comment";
  static const String replay = "replay";

}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: blueColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

class AppColors {
  
  /// white background
  static const Color primaryBackground = Color.fromARGB(255, 255, 255, 255);
  /// grey background
  static const Color primarySecondaryBackground = Color.fromARGB(255, 247, 247, 249);
  /// main widget color blue
  static const Color primaryElement = Color.fromARGB(255, 61, 61, 216);
  /// main text color black
  static const Color primaryText = Color.fromARGB(255, 0, 0, 0);
  // video backgroun color
  static const Color primarybg = Color.fromARGB(210, 32, 47, 62);
  /// main widget text color white
  static const Color primaryElementText = Color.fromARGB(255, 255, 255, 255);
  // main widget text color grey
  static const Color primarySecondaryElementText = Color.fromARGB(255, 102, 102, 102);
  // main widget third color grey
  static const Color primaryThreeElementText = Color.fromARGB(255, 170, 170, 170);

  static const Color primaryFourElementText = Color.fromARGB(255, 204, 204, 204);
  //state color
  static const Color primaryElementStatus = Color.fromARGB(255, 88, 174, 127);

  static const Color primaryElementBg = Color.fromARGB(255, 238, 121, 99);


}

