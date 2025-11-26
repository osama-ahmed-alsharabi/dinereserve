import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dinereserve/core/errors/failure.dart';
import 'package:dinereserve/core/model/advertisement_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AdvertisementRepo {
  Future<Either<Failure, void>> uploadAdvertisement(
    AdvertisementModel ad,
    File imageFile,
  );
}

class AdvertisementRepoImpl implements AdvertisementRepo {
  final SupabaseClient supabaseClient;

  AdvertisementRepoImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, void>> uploadAdvertisement(
    AdvertisementModel ad,
    File imageFile,
  ) async {
    try {
      // 1. Upload Image
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      await supabaseClient.storage
          .from('ads')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = supabaseClient.storage
          .from('ads')
          .getPublicUrl(filePath);

      // 2. Insert Record
      final adWithUrl = AdvertisementModel(
        restaurantId: ad.restaurantId,
        imageUrl: imageUrl,
        startDate: ad.startDate,
        endDate: ad.endDate,
      );

      await supabaseClient.from('advertisements').insert(adWithUrl.toMap());

      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
