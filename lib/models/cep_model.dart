class Cep {
  final String objectId;
  final String cep;
  final String createdAt;
  final String updatedAt;

  Cep({
    required this.objectId,
    required this.cep,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cep.fromJson(Map<String, dynamic> json) {
    return Cep(
      objectId: json['objectId'],
      cep: json['cep'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
    };
  }
}
