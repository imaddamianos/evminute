class UserModel {
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  double? latitude;
  double? longitude;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.latitude,
    this.longitude,
  });
}
