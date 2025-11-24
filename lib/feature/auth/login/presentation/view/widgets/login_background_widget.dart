import 'package:dinereserve/core/utils/app_asset.dart';
import 'package:flutter/material.dart';

class LoginBackgroundWidget extends StatelessWidget {
  const LoginBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          fit: BoxFit.fill,
          width: double.infinity,

          AppAsset.imagesLoginBackground,
        ),
        Positioned(
          bottom: -5,
          left: (MediaQuery.sizeOf(context).width / 2) - 60,
          child: Image.asset(width: 120, AppAsset.imagesLogo),
        ),
      ],
    );
  }
}
