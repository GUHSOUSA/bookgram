import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/features/domain/entities/app_entity.dart';
import 'package:bookgram/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:bookgram/features/presentation/cubit/post/get_single_post/get_single_post_cubit.dart';
import 'package:bookgram/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:bookgram/features/presentation/secondary_page/dettails_page/widget/comment_main_widget.dart';
import 'package:bookgram/constants/injection_container.dart' as di;

class SingleDetailsPage extends StatelessWidget {
  final AppEntity appEntity;

  const SingleDetailsPage({Key? key, required this.appEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => di.sl<CommentCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider<GetSinglePostCubit>(
          create: (context) => di.sl<GetSinglePostCubit>(),
        ),
      ],
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
