
import 'package:flutter/material.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:bookgram/constants/profile_widget.dart';
import 'package:bookgram/constants/injection_container.dart' as di;

import '../../widgets/common_widget.dart';

class FollowersPage extends StatelessWidget {
  final UserEntity user;
  const FollowersPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        elevation: 0.2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: resusableMenuText("Seguidores"),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: user.followers!.isEmpty? _noFollowersWidget() : ListView.builder(itemCount: user.followers!.length,itemBuilder: (context, index) {

                return StreamBuilder<List<UserEntity>>(
                    stream: di.sl<GetSingleUserUseCase>().call(user.followers![index]),
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
                          Navigator.pushNamed(context, PageConst.singleUserProfilePage, arguments: singleUserData.uid);

                        },
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: 40,
                              height: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: profileWidget(imageUrl: singleUserData.profileUrl),
                              ),
                            ),
                            sizeHor(10),
                            Text("${singleUserData.username}", style: const TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w600),)
                          ],
                        ),
                      );
                    }
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  _noFollowersWidget() {
    return const Center(
      child: Text("No Followers", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
    );
  }
}