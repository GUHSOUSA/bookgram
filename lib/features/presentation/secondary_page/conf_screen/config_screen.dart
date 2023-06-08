import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/consts.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../widgets/common_widget.dart';

class ConfigScreen extends StatefulWidget {
  final UserEntity currentUser;
  const ConfigScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  iconTheme: const IconThemeData(color: AppColors.primaryText),
  elevation: 0.2,
  backgroundColor: Colors.white,
  centerTitle: true,
  title: resusableMenuText("Configuraçoes"),


),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, PageConst.editProfilePage,
                        arguments: widget.currentUser);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                  },
                  child: const Text(
                    "Editar Perfil",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: primaryColor),
                  ),
                ),
              ),
              sizeVer(7),
              const Divider(
                thickness: 0.2,
                color: secondaryColor,
              ),
              sizeVer(7),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<AuthCubit>(context).loggedOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, PageConst.signInPage, (route) => false);
                  },
                  child: const Text(
                    "Sair",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.red),
                  ),
                ),
              ),
              sizeVer(7),
            ],
          ),
        )
    )
    );
  }
}
