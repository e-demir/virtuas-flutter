class DetailUser {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;
  final int applicationCount;

  DetailUser({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phoneNumber,
    required this.applicationCount,
  });

  factory DetailUser.fromJson(Map<String, dynamic> json) {
    return DetailUser(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      applicationCount: json['applicationCount'],
    );
  }
}
