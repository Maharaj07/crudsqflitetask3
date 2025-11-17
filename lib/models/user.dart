class User {
  int? id;
  String username;
  String email;
  String password;


  User({this.id, required this.username, required this.email, required this.password});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
    };
    if (id != null) map['id'] = id;
    return map;
  }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}