import 'package:dinereserve/core/utils/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingWidget({
    super.key,
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (isLoading)
          Container(
            height: double.infinity,
            color: Colors.black.withAlpha(200), 
            child: Container(
              child: Lottie.asset(
                AppAsset.lottieLoading          
              ),
            ),
          ),
      ],
    );
  }
}
