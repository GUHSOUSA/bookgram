import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:bookgram/features/presentation/page/search/widget/search_main_widget.dart';
import 'package:bookgram/constants/injection_container.dart' as di;

import '../../../domain/entities/user/user_entity.dart';

class SearchPage extends StatelessWidget {
  final UserEntity currentUser;
  const SearchPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCubit>(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: SearchMainWidget(currentUser: currentUser,),
    );
  }
}
