import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:bookgram/features/presentation/cubit/credentail/credential_cubit.dart';
import 'package:bookgram/features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:bookgram/features/presentation/page/credential/sign_in_page.dart';
import 'package:bookgram/features/presentation/main_screen/main_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'features/presentation/cubit/user/user_cubit.dart';
import 'constants/on_generate_route.dart';
import 'constants/injection_container.dart' as di;
import 'package:flutter/services.dart';

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child)=>
          MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "bookgram",

            
            onGenerateRoute: OnGenerateRoute.route,
            initialRoute: "/",
            routes: {
              "/": (context) {
                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    if (authState is Authenticated) {
                      return MainScreen(uid: authState.uid);

                    } else {
                      return const SignInPage();
                    }
                  },
                );
              }
            }
          )
      
        
      ),
    );
  }
}


