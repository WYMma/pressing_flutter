class Transporteur {
  String first_name;
  String last_name;
  String cin;
  String personnelID;
  String? email;

  Transporteur({
    required this.first_name,
    required this.last_name,
    required this.cin,
    required this.personnelID,
    required this.email
  });

  factory Transporteur.fromJson(Map<String, dynamic> json) {
    return Transporteur(
      first_name: json['first_name'],
      last_name: json['last_name'],
      cin: json['cin'].toString(),
      personnelID: json['personnelID'].toString(),
      email: json['email']
    );
  }
}