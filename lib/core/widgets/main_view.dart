import 'package:dinereserve/core/widgets/custom_nav_bar.dart';
import 'package:dinereserve/feature/home/presentation/view/widgets/home_body_widget.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeBodyWidget(),
    Center(child: Text("Booking")),
    Center(child: Text("Bot")),
    Center(child: Text("Favorite")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
