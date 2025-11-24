import 'package:dinereserve/core/widgets/custom_nav_bar_rest_widget.dart';
import 'package:dinereserve/feature/home_rest/presentation/view/home_rest_view.dart';
import 'package:flutter/material.dart';

class MainRestView extends StatefulWidget {
  const MainRestView({super.key});

  @override
  State<MainRestView> createState() => _MainRestViewState();
}

class _MainRestViewState extends State<MainRestView> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeRestView(),
    Center(child: Text("Booking")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: CustomNavBarRestWidget(
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
