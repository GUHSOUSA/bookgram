
import 'package:flutter/material.dart';
import '../../../constants/consts.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  const ProfileFormWidget({Key? key, this.title, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TextFormField(

          controller: controller,
          style: const TextStyle(color: primaryColor),
          decoration: InputDecoration(
              hintText: title,
              border: InputBorder.none,
              labelStyle: const TextStyle(color: primaryColor)
          ),
        ),
        Container(
          width: double.infinity,
          height: 0.5,
          color: secondaryColor,
        )
      ],
    );
  }
}
