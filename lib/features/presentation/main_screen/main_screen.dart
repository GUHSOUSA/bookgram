import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/features/presentation/page/activity/activity_page.dart';
import 'package:bookgram/features/presentation/page/post/upload_post_page.dart';
import 'package:bookgram/features/presentation/page/profile/profile_page.dart';
import 'package:bookgram/features/presentation/page/search/search_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/consts.dart';
import '../cubit/user/get_single_user/get_single_user_cubit.dart';
import '../page/home/home_page.dart';

class MainScreen extends StatefulWidget {
  final String uid;

  const MainScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(

            backgroundColor: backGroundColor,
            bottomNavigationBar: Container(
            width: 375.w,
            height: 58.h,
            decoration: BoxDecoration(
              color: AppColors.primaryElement,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.h),
                  topRight: Radius.circular(20.h)
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1
                ),
              ],
            ),
            child: BottomNavigationBar(
              onTap: navigationTapped,
              currentIndex: _currentIndex,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedItemColor: AppColors.primaryElement,
              unselectedItemColor: AppColors.primaryFourElementText,


              items: [
                BottomNavigationBarItem(
                    label: "home",
                    icon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/home.png", color: AppColors.primaryThreeElementText,),),
                    activeIcon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/home.png", color: AppColors.primaryElement,),
                    )
                ),
                BottomNavigationBarItem(
                    label: "search",
                    icon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/search.png", color: AppColors.primaryThreeElementText,),),
                    activeIcon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/search.png", color: AppColors.primaryElement,),
                    )
                ),
                BottomNavigationBarItem(
                    label: "play",
                    icon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/play.png", color: AppColors.primaryThreeElementText,),),
                    activeIcon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/play.png", color: AppColors.primaryElement,),
                    )
                ),
                BottomNavigationBarItem(
                    label: "trofeu",
                    icon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/trofeu.png", color: AppColors.primaryThreeElementText,),),
                    activeIcon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/trofeu.png", color: AppColors.primaryElement,),
                    )
                ),
                BottomNavigationBarItem(
                    label: "usuario",
                    icon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/usuario.png", color: AppColors.primaryThreeElementText,),),
                    activeIcon: SizedBox(
                      width: 15.w,
                      height: 15.h,
                      child: Image.asset("assets/icons/usuario.png", color: AppColors.primaryElement,),
                    )
                ),
              ],

            ),
          ),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                HomePage(currentUser: currentUser,),
                SearchPage(currentUser: currentUser,),
                UploadPostPage(currentUser: currentUser),
                const ActivityPage(),
                ProfilePage(currentUser: currentUser,)
              ],
            ),

          );
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
