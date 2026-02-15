import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visite.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.88/musee-api/public/index.php";

  /// Récupère toutes les visites
  static Future<List<Visite>> fetchVisites() async {
    final response = await http.get(Uri.parse("$baseUrl?action=visites"));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((v) => Visite.fromJson(v)).toList();
    } else {
      throw Exception("Erreur API: ${response.statusCode}");
    }
  }
}