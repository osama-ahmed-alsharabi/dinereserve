import 'package:dinereserve/feature/home/presentation/view/widgets/home_app_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeBodyWidget extends StatelessWidget {
  const HomeBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(children: [HomeAppBarWidget(), SizedBox(height: 32)]),
      ),
    );
  }
}
