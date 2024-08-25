class Client {
  String first_name;
  String last_name;
  String cin;
  String clientID;
  String? email;

  Client({
    required this.first_name,
    required this.last_name,
    required this.cin,
    required this.clientID,
    required this.email
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      first_name: json['first_name'],
      last_name: json['last_name'],
      cin: json['cin'].toString(),
      clientID: json['clientID'].toString(),
      email: json['email']
    );
  }
}