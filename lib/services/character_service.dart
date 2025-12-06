import 'dart:convert';
import 'package:as_projeto/constantes.dart';
import 'package:as_projeto/models/character.dart';
import 'package:http/http.dart' as http;

class CharacterService {

  Future<List<Character>> getCharacter() async {
    try {
      var response = await http.get(Uri.parse('$BASE_URL/cards')).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception("Tempo de conexão excedido. Verifique sua internet.");
        },
      );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)["cards"];
        var all = data.map<Character>((item) => Character.fromJson(item)).toList();
        var seenNames = <String>{};
        var filtered = <Character>[];
        for (var c in all) {
        if (c.imageUrl.trim().isEmpty) continue;
          var key = c.name.trim().toLowerCase();
        if (seenNames.add(key)) {
          filtered.add(c);
        }
      }
      return filtered;
 } else {
        throw Exception("Erro ao buscar dados da API. Código: ${response.statusCode}");
      }
    } catch (e) {
      if (e.toString().contains("SocketException") || e.toString().contains("network")) {
        throw Exception("Erro de conexão. Verifique sua internet.");
      } else if (e.toString().contains("TimeoutException") || e.toString().contains("Tempo")) {
        throw Exception("Tempo de conexão excedido. Tente novamente.");
      } else {
        throw Exception("Erro ao carregar dados: ${e.toString()}");
      }
    }
  }
}