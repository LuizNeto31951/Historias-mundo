// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:historias_mundo/autenticador.dart';

const URL_HISTORIAS = "http://10.0.2.2:5001/historias";
const URL_HISTORIA = "http://10.0.2.2:5001/historia";

const URL_CURTIU = "http://10.0.2.2:5002/curtiu";
const URL_CURTIR = "http://10.0.2.2:5002/curtir";
const URL_DESCURTIR = "http://10.0.2.2:5002/descurtir";

const URL_ARQUIVOS = "http://10.0.2.2:5004/";

class ServicoHistorias {
  Future<List<dynamic>> getHistorias(int ultimoId, int tamanhoPagina) async {
    final resposta =
        await http.get(Uri.parse('$URL_HISTORIAS/$ultimoId/$tamanhoPagina'));
    if (resposta.statusCode != 200) {
      throw Exception('Erro ao buscar historias');
    }

    return jsonDecode(resposta.body);
  }

  Future<List<dynamic>> findHistorias(
      int ultimoProduto, int tamanhoPagina, String titulo) async {
    final resposta = await http
        .get(Uri.parse("$URL_HISTORIAS/$ultimoProduto/$tamanhoPagina/$titulo"));
    final historias = jsonDecode(resposta.body);

    return historias;
  }

  Future<Map<String, dynamic>> findHistoria(int idHistoria) async {
    final resposta = await http.get(Uri.parse("$URL_HISTORIA/$idHistoria"));
    final historias = jsonDecode(resposta.body);

    return historias;
  }
}

class ServicoCurtidas {
  Future<bool> curtiu(Usuario usuario, int idHistoria) async {
    final resposta =
        await http.get(Uri.parse("$URL_CURTIU/${usuario.email}/$idHistoria"));
    final resultado = jsonDecode(resposta.body);

    return resultado["curtiu"] as bool;
  }

  Future<dynamic> curtir(Usuario usuario, int idHistoria) async {
    final resposta =
        await http.post(Uri.parse("$URL_CURTIR/${usuario.email}/$idHistoria"));

    return jsonDecode(resposta.body);
  }

  Future<dynamic> descurtir(Usuario usuario, int idHistoria) async {
    final resposta = await http
        .post(Uri.parse("$URL_DESCURTIR/${usuario.email}/$idHistoria"));

    return jsonDecode(resposta.body);
  }
}

String formatarCaminhoArquivo(String arquivo) {
  return '$URL_ARQUIVOS/$arquivo';
}
