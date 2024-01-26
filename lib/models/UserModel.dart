class UserModel {
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String imageUrl;
  double? latitude;
  double? longitude;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.imageUrl,
    this.latitude,
    this.longitude,
  });
}
