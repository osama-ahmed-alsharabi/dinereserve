import 'package:dinereserve/core/utils/app_asset.dart';
import 'package:flutter/material.dart';

class RegisterBackgroundWidget extends StatelessWidget {
  const RegisterBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          fit: BoxFit.fill,
          width: double.infinity,

          AppAsset.imagesRegisterBackground,
        ),
        Positioned(
          top: 15,
          left: 15,
          child: CircleAvatar(
            backgroundColor: Colors.white38,
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -35,
          left: (MediaQuery.sizeOf(context).width / 2) - 60,
          child: Image.asset(width: 120, AppAsset.imagesLogo),
        ),
      ],
    );
  }
}
