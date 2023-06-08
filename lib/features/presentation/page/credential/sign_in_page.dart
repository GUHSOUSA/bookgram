import 'package:bookgram/features/presentation/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/presentation/cubit/credentail/credential_cubit.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../main_screen/main_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            toast("Invalid Email and Password");
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
      )
    );
  }

  _bodyWidget() {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
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
                  resusableText("Email"),
                      SizedBox(
                        height: 5.h,
                      ),
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
                )
              ),
              forgotPassword(() async {

                }, "Esqueceu a senha?"),
              buildLogInAdnRegButton( "Entrar", "login", () async {
                  _signInUser();
                }),
                buildLogInAdnRegButton( "Cadastra", "register", () async {
                  Navigator.pushNamedAndRemoveUntil(context, PageConst.signUpPage, (route) => false);
                }),

                ],
              ),





      ),
    );
  
  }

  void _signInUser() {
    setState(() {
    });
    BlocProvider.of<CredentialCubit>(context).signInUser(
      email: _emailController.text,
      password: _passwordController.text,
    ).then((value) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
    });
  }
}
