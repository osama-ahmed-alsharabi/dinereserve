import 'package:dinereserve/feature/home_rest/presentation/view/widgets/home_reset_app_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeRestView extends StatelessWidget {
  const HomeRestView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
        child: Column(
          children: [
            HomeRestAppBarWidget(),
            
          ],
        ),
      ),
    );
  }
}