class ViaCepModel {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  ViaCepModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory ViaCepModel.fromJson(Map<String, dynamic> json) {
    return ViaCepModel(
      cep: json['cep'],
      logradouro: json['logradouro'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
    );
  }
}
