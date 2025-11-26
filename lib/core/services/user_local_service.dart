import 'package:hive/hive.dart';
import 'package:dinereserve/core/model/user_model.dart';

class UserLocalService {
  static const String userBoxName = "user_box";
  static const String userKey = "currentUser";

  final Box<UserModel> box;

  UserLocalService(this.box);

  Future<void> saveUser(UserModel user) async {
    await box.put(userKey, user);
  }

  UserModel? getUser() {
    return box.get(userKey);
  }

  bool isLoggedIn() {
    return box.get(userKey) != null;
  }

  Future<void> logout() async {
    await box.delete(userKey);
  }
}
