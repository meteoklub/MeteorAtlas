import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/models/warnings.dart';

class WarningRepository {
  final String apiUrl;

  WarningRepository({required this.apiUrl});

  Future<List<LongWarning>> getAllWarnings() async {
    final response = await http.get(Uri.parse('$apiUrl/warnings/list'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => LongWarning.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load warnings');
    }
  }

  Future<LongWarning?> getWarningDetailsById(String warningId) async {
    final response = await http.get(Uri.parse('$apiUrl/warnings/$warningId'));

    if (response.statusCode == 200) {
      return LongWarning.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load warning details');
    }
  }
}
