class BoothModel {
  int id;
  bool isActive;
  String teamName;
  String name;
  String description;
  String boothType;

  BoothModel({
    required this.id,
    required this.teamName,
    required this.name,
    required this.description,
    required this.boothType,
    this.isActive = false,
  });

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isActive': isActive,
      'teamName': teamName,
      'name': name,
      'description': description,
      'boothType': boothType,
    };
  }

  // JSON에서 객체로 변환하는 메서드
  factory BoothModel.fromJson(Map<String, dynamic> json) {
    return BoothModel(
      id: json['id'],
      isActive: json['isActive'] ?? false,
      teamName: json['teamName'],
      name: json['name'],
      description: json['description'],
      boothType: json['boothType'],
    );
  }

  copyWith({
    int? id,
    bool? isActive,
    String? teamName,
    String? name,
    String? description,
    String? boothType,
  }) {
    return BoothModel(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      teamName: teamName ?? this.teamName,
      name: name ?? this.name,
      description: description ?? this.description,
      boothType: boothType ?? this.boothType,
    );
  }
}
