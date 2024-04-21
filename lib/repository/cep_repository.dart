import 'dart:convert';

import 'package:dio_cep_manager/models/cep_model.dart';
import 'package:http/http.dart' as http;

class CepRepository {
  final headers = {
    "X-Parse-Application-Id": "kJW1xJ2JuugZrIOGboxZhD9lFqftEbZ7mMyxUi9w",
    "X-Parse-REST-API-Key": "7Q3ivnDgfDa89NLxnn4tX7ciXXGm9KboAFx5rqgb",
  };

  Future<List<String>> getCeps() async {
    final response = await http.get(
        Uri.parse("https://parseapi.back4app.com/classes/cep"),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<String> ceps = data.map((cep) => Cep.fromJson(cep).cep).toList();
      return ceps;
    } else {
      throw Exception('Failed to load CEPs');
    }
  }

  Future<String?> getCep(String cep) async {
    final response = await http.get(
        Uri.parse("https://parseapi.back4app.com/classes/cep/$cep"),
        headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Cep.fromJson(data).cep;
    } else {
      throw Exception('Failed to load CEP');
    }
  }

  Future<void> postCep(String cep) async {
    final Map<String, String> body = {
      "cep": cep,
    };
    final response = await http.post(
      Uri.parse("https://parseapi.back4app.com/classes/cep"),
      headers: {
        "Content-Type": "application/json",
        ...headers,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post CEP');
    }
  }

  Future<String?> getViaCep(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String logradouro = data['logradouro'];
      String bairro = data['bairro'];
      String localidade = data['localidade'];
      String uf = data['uf'];

      return '$logradouro, $bairro, $localidade - $uf, $cep';
    } else {
      return null;
    }
  }
}

Future<void> postViaCep(String cep) async {
  print(cep);
  try {
    await CepRepository().postCep(cep);
  } catch (error) {
    print(error);
  }
}
