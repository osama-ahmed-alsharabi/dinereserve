import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileRestaurantHeader extends StatefulWidget {
  final List<String> images;
  const ProfileRestaurantHeader({super.key, required this.images});

  @override
  State<ProfileRestaurantHeader> createState() =>
      _ProfileRestaurantHeaderState();
}

class _ProfileRestaurantHeaderState extends State<ProfileRestaurantHeader> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 270,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text("No table images yet", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 270,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(widget.images[index], fit: BoxFit.cover),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        if (widget.images.isNotEmpty)
          SizedBox(
            height: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 12 : 8,
                  height: currentIndex == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.primaryColor
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
