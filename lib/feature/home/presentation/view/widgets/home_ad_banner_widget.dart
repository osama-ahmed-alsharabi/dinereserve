import 'package:dinereserve/core/model/advertisement_model.dart';
import 'package:flutter/material.dart';

class HomeAdBannerWidget extends StatelessWidget {
  final AdvertisementModel ad;

  const HomeAdBannerWidget({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(ad.imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
    );
  }
}
