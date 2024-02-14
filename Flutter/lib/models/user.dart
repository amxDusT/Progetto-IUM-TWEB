class User {
  final String username;
  final int id;
  final String role;
  const User({
    required this.username,
    required this.role,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'id': id,
    'ruolo': role,
  };

  factory User.fromJson(Map<String, dynamic> json){
    return User(id: json['id'], role: json['ruolo'], username: json['username']);
  }
  
}
