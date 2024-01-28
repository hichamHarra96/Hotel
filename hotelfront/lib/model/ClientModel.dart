class RoomClient {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;

  RoomClient(
      {
      this.id='',
      required this.fullName,
      required this.email,
      required this.phoneNumber});

  factory RoomClient.fromJson(Map<String, dynamic> json) {
    return RoomClient(
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

}
