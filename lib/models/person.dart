class Person {
  int? id;
  String name;
  String email;
  int age;
  String dob; // stored as ISO string YYYY-MM-DD


  Person({this.id, required this.name, required this.email, required this.age, required this.dob});


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'email': email,
      'age': age,
      'dob': dob,
    };
    if (id != null) map['id'] = id;
    return map;
  }


  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
      dob: map['dob'],
    );
  }
}