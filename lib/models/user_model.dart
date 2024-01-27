// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? password;
  final int funding;
  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.funding = 0,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'funding': funding,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      funding: map['funding'] as int,
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? password,
    int? funding,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      funding: funding ?? this.funding,
    );
  }
}
