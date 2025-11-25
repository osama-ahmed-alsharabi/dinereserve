import 'package:dartz/dartz.dart';
import 'package:dinereserve/core/errors/failure.dart';
import 'package:dinereserve/core/errors/supabase_error_handler.dart';
import 'package:dinereserve/core/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserProfileRepo {
  Future<Either<Failure, UserModel>> getUserProfile();
  Future<Either<Failure, void>> updateUserProfile(UserModel user);
  Future<Either<Failure, void>> logout();
}

class UserProfileRepoImpl implements UserProfileRepo {
  final SupabaseClient supabaseClient;

  UserProfileRepoImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, UserModel>> getUserProfile() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        return left(ServerFailure("User not authenticated"));
      }

      final data = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return right(UserModel.fromMap(data));
    } catch (e) {
      if (e is AuthException) {
        return left(ServerFailure(SupabaseErrorHandler.parseAuthException(e)));
      } else if (e is PostgrestException) {
        return left(
          ServerFailure(SupabaseErrorHandler.parseDatabaseException(e)),
        );
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await supabaseClient.auth.signOut();
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserModel user) async {
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser == null) {
        return left(ServerFailure("User not authenticated"));
      }

      await supabaseClient
          .from('profiles')
          .update({"full_name": user.fullName, "age": user.age})
          .eq('id', currentUser.id);

      return right(null);
    } catch (e) {
      if (e is PostgrestException) {
        return left(
          ServerFailure(SupabaseErrorHandler.parseDatabaseException(e)),
        );
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
