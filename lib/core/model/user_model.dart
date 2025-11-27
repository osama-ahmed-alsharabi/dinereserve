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

  @HiveField(5)
  final String? image;

  @HiveField(6)
  final String? id; // Supabase user UUID

  UserModel({
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    this.fakeEmail,
    this.password,
    this.image,
    this.id,
  });

  // Convert FROM database map (Supabase)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map["full_name"] ?? "",
      phoneNumber: map["phone"] ?? "",
      age: map["age"]?.toString() ?? "",
      image: map["image"],
      id: map["id"], // Get UUID from Supabase
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
      "image": image,
      "id": id,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? age,
    String? fakeEmail,
    String? password,
    String? image,
    String? id,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      fakeEmail: fakeEmail ?? this.fakeEmail,
      password: password ?? this.password,
      image: image ?? this.image,
      id: id ?? this.id,
    );
  }
}
