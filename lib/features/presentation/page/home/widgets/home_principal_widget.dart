import 'package:bookgram/features/domain/usecases/firebase_usecases/post/read_single_post_usecase.dart';
import 'package:bookgram/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:bookgram/features/presentation/page/home/widgets/single_book_widget.dart';
import 'package:bookgram/features/presentation/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookgram/constants/injection_container.dart' as di;
import '../../../../../constants/profile_widget.dart';
import '../../../../domain/entities/app_entity.dart';
import '../../../../domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import '../../../cubit/user/user_cubit.dart';
import '../../../secondary_page/reading_page/reading.dart';
import 'home_page_widget.dart';


class HomePageWidgetPrincipals extends StatefulWidget {
  final UserEntity currentUser;

  const HomePageWidgetPrincipals({super.key, required this.currentUser});

  @override
  State<HomePageWidgetPrincipals> createState() =>
      _HomePageWidgetPrincipalsState();
}

class _HomePageWidgetPrincipalsState extends State<HomePageWidgetPrincipals> {
 final TextEditingController _searchController = TextEditingController();
 final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUsers(user: UserEntity());
    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());

    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.primaryText),
          elevation: 0.2,
          backgroundColor: Colors.white,
          centerTitle: true,
         title: resusableMenuText("BookGram"),

          
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(top: 20.h),
                child: Text(
                  "Bem vindo",
                  style: TextStyle(
                      color: AppColors.primaryThreeElementText,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.h),
                child: Text(
                  "${widget.currentUser.username}",
                  style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              BlocBuilder<PostCubit, PostState>(
                builder: (context, postState) {
                  if (postState is PostLoaded) {
                    final filterAllUsers = postState.posts
                        .where((user) =>
                            user.title!.startsWith(_searchController.text) ||
                            user.title!.toLowerCase().startsWith(
                                _searchController.text.toLowerCase()) ||
                            user.title!.contains(_searchController.text) ||
                            user.title!
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase()))
                        .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchViewWidget(
                          _searchController,
                        ),
                        sizeVer(10),
                        _searchController.text.isNotEmpty
                            ? SizedBox(
                                height: 550.h,
                                child: ListView.builder(
                                      itemCount: filterAllUsers.length,
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,

                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.pushNamed(context, PageConst.commentPage, arguments: AppEntity(uid: widget.currentUser.uid, postId: filterAllUsers[index].postId));
                                          },
                                          child: Container(
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
                                                            child: profileWidget(imageUrl: filterAllUsers[index].postImageUrl)
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
                                                                child: resusableMenuText("${filterAllUsers[index].title}")),
                                                            Container(
                                                              margin: EdgeInsets.only(top: 8.h),
                                                                width: 100.w,
                                                                child: resusableText("${filterAllUsers[index].author}")),

                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(bottom: 10.h),
                                                            child: Row(

                                                              children: [
                                                                const Icon(Icons.comment, color: AppColors.primaryThreeElementText,),
                                                                SizedBox(width: 5.w,),
                                                                resusableMenuText("${filterAllUsers[index].totalComments}", color: AppColors.primaryThreeElementText),

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
                                                      Icon(Icons.favorite_outline, color: Colors.red, size: 20.w, ),
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
                                      }),
                                )

                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 15.h, left: 5.w),
                                      child:
                                          resusableMenuText("Continuar lendo")),

                                      Container(
                                        margin: EdgeInsets.only(top: 15.w, left: 5.w),
                                        height: 280.h,

                                        child: widget.currentUser.reading!.isEmpty? _noReadingYetWidget() :
                                        ListView.builder(
                                            scrollDirection:
                                            Axis.horizontal,
                                            itemCount: widget.currentUser.reading!.length,itemBuilder: (context, index) {

                                          return StreamBuilder<List<PostEntity>>(
                                              stream: di.sl<ReadSinglePostUseCase>().call(widget.currentUser.reading![index]),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData == false) {
                                                  return const CircularProgressIndicator();
                                                }
                                                if (snapshot.data!.isEmpty) {
                                                  return Container();
                                                }
                                                final singleUserData = snapshot.data!.first;
                                                return  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ReadPdf(pdfUrl: '${singleUserData.postPdfUrl}',),
                                                        ),
                                                      );
                                                    },
                                                  child: Container(
                                                      margin: EdgeInsets.only(right: 15.w, bottom: 10.h),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15.w),
                                                        boxShadow: [
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
                                                                Container(
                                                                  height: 280.h,
                                                                  width: 180.w,
                                                                  child: ColorFiltered(
                                                                      colorFilter: ColorFilter.mode(
                                                                          Colors.black.withOpacity(0.6), BlendMode.darken),
                                                                      child:
                                                                      profileWidget(imageUrl: singleUserData.postImageUrl)),
                                                                ),
                                                                Positioned.fill(
                                                                  top: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  bottom: 0,
                                                                  child: IconButton(
                                                                    icon: Icon(
                                                                    Icons.play_circle_fill,
                                                                    color: Colors.white,
                                                                    size: 80,
                                                                  ),
                                                                    onPressed: (){Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => ReadPdf(pdfUrl: '${singleUserData.postPdfUrl}',),
                                                                      ),
                                                                    );},
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 35,
                                                                  left: 20,

                                                                  child:
                                                                  Container(
                                                                      height: 30.h,
                                                                      width: 120.w,
                                                                      child: resusableMenuText("${singleUserData.title}",
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
                                                          )))
                                                );
                                              }
                                          );
                                        }),
                                      ),


                                  menuText(() {
                                    Navigator.pushNamed(
                                        context, PageConst.allBooks);
                                  }),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  BlocBuilder<PostCubit, PostState>(
                                    builder: (context, postState) {
                                      if (postState is PostLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (postState is PostFailure) {
                                        toast(
                                            "Some Failure occured while creating the post");
                                      }
                                      if (postState is PostLoaded) {
                                        return postState.posts.isEmpty
                                            ? _noPostsYetWidget()
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    postState.posts.length >= 10
                                                        ? 10
                                                        : postState
                                                            .posts.length,
                                                itemBuilder: (context, index) {
                                                  final post =
                                                      postState.posts[index];
                                                  return BlocProvider(
                                                    create: (context) =>
                                                        di.sl<PostCubit>(),
                                                    child: SingleBookWidget(
                                                        post: post),
                                                  );
                                                },
                                              );
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ]),
          ),
        ));
  }

  _noReadingYetWidget() {
    return Container(
        margin: EdgeInsets.only(right: 15.w, bottom: 10.h, top: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.w),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
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
                        child: Image.asset(
                          "assets/erro.jpg",
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned.fill(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add,
                            color: Colors.white),
                        resusableMenuText("Comece uma leitura", color: Colors.white, fontSize: 14)
                      ],
                    ),
                  ),

                ],
              ),
            )));
  }

  _noPostsYetWidget() {
    return Container(
      width: double.infinity,
      height: 150.h,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            height: 130.h,
            width: 83.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.w),
              child: Transform.scale(
                  scale: 1.0, child: Image.asset("assets/erro.jpg")),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 200.w,
                child: resusableMenuText("Poste um livro que você gosta"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
