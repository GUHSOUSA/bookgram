import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:bookgram/features/presentation/page/post/widget/upload_post_main_widget.dart';
import 'package:bookgram/constants/injection_container.dart' as di;

class UploadPostPage extends StatelessWidget {
  final UserEntity currentUser;

  const UploadPostPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => di.sl<PostCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser),
    );
  }
}
