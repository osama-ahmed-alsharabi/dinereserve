class UserModel {
  final String fullName;
  final String phoneNumber;
  final String age;
  final String? fakeEmail;
  final String? password;

  UserModel({
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    this.fakeEmail,
    this.password,
  });
}
