class APIKey {
  final int id;
  final String name;
  final String api_key;
  final DateTime createdAt;
  final DateTime updatedAt;

  APIKey({
    required this.id,
    required this.name,
    required this.api_key,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from a JSON object
  factory APIKey.fromJson(Map<String, dynamic> json) {
    return APIKey(
      id: json['id'],
      name: json['name'],
      api_key: json['api_key'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'api_key': api_key,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Static list to store API keys during runtime
  static List<APIKey> apiKeyList = [];

  // Method to add an API key to the list
  static void addApiKey(APIKey apiKey) {
    apiKeyList.add(apiKey);
  }

  // Method to remove an API key from the list by ID
  static void removeApiKey(int id) {
    apiKeyList.removeWhere((apiKey) => apiKey.id == id);
  }

  // Method to update an API key in the list by ID
  static void updateApiKey(APIKey updatedApiKey) {
    int index = apiKeyList.indexWhere((apiKey) => apiKey.id == updatedApiKey.id);
    if (index != -1) {
      apiKeyList[index] = updatedApiKey;
    }
  }

  // Method to find an API key by name
  static APIKey? findApiKeyByName(String name) {
    return apiKeyList.firstWhere((apiKey) => apiKey.name == name, orElse: () => null as APIKey);
  }

  @override
  String toString() {
    return 'APIKey{id: $id, name: $name, api_key: $api_key}';
  }
}
