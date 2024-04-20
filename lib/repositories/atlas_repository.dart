import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/api/api_constant.dart';
import '../domain/models/atlas_model.dart';

class AtlasApiProvider {
  final String apiUrl;

  // Singleton instance
  static final AtlasApiProvider _instance =
      AtlasApiProvider._internal(apiUrl: ApiConstants.apiUrl);

  factory AtlasApiProvider() {
    return _instance;
  }

  AtlasApiProvider._internal({required this.apiUrl});

  Future<List<AtlasModel>> getAtlasList() async {
    final response = await http.get(Uri.parse('$apiUrl/atlas/list'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => AtlasModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load atlas list');
    }
  }

  Future<AtlasModel> getAtlasById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/atlas/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return AtlasModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load atlas with id: $id');
    }
  }
}
