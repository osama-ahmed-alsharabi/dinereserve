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

  Future<Either<Failure, List<AdvertisementModel>>> fetchAdvertisements(
    String restaurantId,
  );

  Future<Either<Failure, void>> deleteAdvertisement(
    String adId,
    String imageUrl,
  );

  Future<Either<Failure, void>> updateAdvertisement(AdvertisementModel ad);
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

  @override
  Future<Either<Failure, List<AdvertisementModel>>> fetchAdvertisements(
    String restaurantId,
  ) async {
    try {
      final data = await supabaseClient
          .from('advertisements')
          .select()
          .eq('restaurant_id', restaurantId)
          .order('created_at', ascending: false);

      final ads = (data as List)
          .map((e) => AdvertisementModel.fromMap(e))
          .toList();
      return right(ads);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAdvertisement(
    String adId,
    String imageUrl,
  ) async {
    try {
      // 1. Delete from Storage
      // Extract file path from URL. Assuming URL structure: .../ads/filename.ext
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      // The path in bucket is usually the last segment if we uploaded directly to root of bucket
      // But let's be safe. If we used getPublicUrl, the path is after /storage/v1/object/public/bucket_name/
      // A simpler way if we know we just stored the filename:
      final fileName = pathSegments.last;

      await supabaseClient.storage.from('ads').remove([fileName]);

      // 2. Delete from Database
      await supabaseClient.from('advertisements').delete().eq('id', adId);

      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAdvertisement(
    AdvertisementModel ad,
  ) async {
    try {
      await supabaseClient
          .from('advertisements')
          .update(ad.toMap())
          .eq('id', ad.id!);
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
