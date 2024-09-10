class LSPressingModel {
  String name;
  String writtenAddress;
  String googleMapAddress;
  String phoneNumber;
  String description;
  String image;

  LSPressingModel({
    required this.name,
    required this.writtenAddress,
    required this.googleMapAddress,
    required this.phoneNumber,
    required this.description,
    required this.image,
  });

  static List<LSPressingModel> pressings = [];

  factory LSPressingModel.fromJson(Map<String, dynamic> json) {
    return LSPressingModel(
      name: json['name'],
      writtenAddress: json['written_address'],
      googleMapAddress: json['google_map_address'],
      phoneNumber: json['phone_number'],
      description: json['description'],
      image: json['image'],
    );
  }


  @override
  String toString() {
    return 'LSPressingModel{name: $name, writtenAddress: $writtenAddress, googleMapAddress: $googleMapAddress, phoneNumber: $phoneNumber, image: $image, description: $description}';
  }
}
