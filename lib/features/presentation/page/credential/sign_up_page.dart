import 'package:bookgram/features/presentation/widgets/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:bookgram/features/presentation/cubit/credentail/credential_cubit.dart';
import 'package:bookgram/features/presentation/main_screen/main_screen.dart';

import '../../widgets/common_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: BlocConsumer<CredentialCubit, CredentialState>(
          listener: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            }
            if (credentialState is CredentialFailure) {
              toastInfo(msg: "Email ou senha invalida");
            }
          },
          builder: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  if (authState is Authenticated) {
                    return MainScreen(uid: authState.uid);
                  } else {
                    return _bodyWidget();
                  }
                },
              );
            }
            return _bodyWidget();
          },
        ));
  }

  _bodyWidget() {
    return Scaffold(
      appBar: buildAppBar("Cadastrar"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildThirdPartLogin(
              context,
            ),
            Center(child: resusableText("Ou  use sua conta de email")),
            Container(
                margin: EdgeInsets.only(top: 36.h),
                padding: EdgeInsets.only(left: 25.2, right: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    resusableText("Usuario"),
                    buildTextField(
                      "Ensira seu usuario",
                      "email",
                      "usuario",
                      _usernameController,
                    ),
                    resusableText("Email"),
                    buildTextField(
                      "Ensira seu email",
                      "email",
                      "usuario",
                      _emailController,
                    ),
                    resusableText("senha"),
                    SizedBox(
                      height: 5.h,
                    ),
                    buildTextField("Ensira sua senha", "password", "lock",
                        _passwordController),
                  ],
                )),
            forgotPassword(() async {
              Navigator.pushNamedAndRemoveUntil(
                  context, PageConst.signInPage, (route) => false);
            }, "Ou faça login"),
            buildLogInAdnRegButton("Cadastrar", "login", () async {
              _signUpUser();
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _signUpUser() async {
    setState(() {});
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
              user: UserEntity(
                  email: _emailController.text,
                  password: _passwordController.text,
                  bio: _bioController.text,
                  username: _usernameController.text,
                  totalPosts: 0,
                  totalFollowing: 0,
                  followers: const [],
                  totalFollowers: 0,
                  website: "",
                  following: const [],
                  name: "",
                read: const[],
                totalRead: 0,
                reading: const [],
                totalReading: 0,
                likes: const[],
                totalLikes: 0,
                totalWords: 0
        ))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _usernameController.clear();
      _bioController.clear();
      _emailController.clear();
      _passwordController.clear();
    });
  }
}
