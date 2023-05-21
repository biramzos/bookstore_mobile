class Data {
  int id;
  String username;
  String token;

  Data({
    required this.id,
    required this.username,
    required this.token
  });

  Data.fromJson(dynamic data):
        id = data['id'],
        username = data['username'],
        token = data['token'];

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "token": token,
  };
}