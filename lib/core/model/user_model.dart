import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String phoneNumber;

  @HiveField(2)
  final String age;

  @HiveField(3)
  final String? fakeEmail;

  @HiveField(4)
  final String? password;

  UserModel({
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    this.fakeEmail,
    this.password,
  });

  // Convert FROM database map (Supabase)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map["full_name"] ?? "",
      phoneNumber: map["phone"] ?? "",
      age: map["age"]?.toString() ?? "",
    );
  }

  // Convert TO map (Local Save)
  Map<String, dynamic> toMap() {
    return {
      "full_name": fullName,
      "phone": phoneNumber,
      "age": age,
      "fake_email": fakeEmail,
      "password": password,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? age,
    String? fakeEmail,
    String? password,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      fakeEmail: fakeEmail ?? this.fakeEmail,
      password: password ?? this.password,
    );
  }
}
