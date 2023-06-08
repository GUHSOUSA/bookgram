
import 'package:flutter/material.dart';
import 'package:bookgram/constants/consts.dart';

import '../../widgets/common_widget.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        elevation: 0.2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: resusableMenuText("Ranking"),

      ),
    );
  }
}
