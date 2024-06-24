class User {
  final int? id; // Optional ID for SQLite primary key
  final String username;
  final String email;
  final String password;

  User({
    this.id, // ID is optional for creating new users
    required this.username,
    required this.email,
    required this.password,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract a User object from a Map object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}
