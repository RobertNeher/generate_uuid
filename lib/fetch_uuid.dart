import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<List<String>> fetchUUID(int? count) async {
  List<String> UUIDs = <String>[];
  Uri uri = Uri.https(
      'www.uuidtools.com', '/api/generate/v4/count/${count.toString()}');
  try {
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      UUIDs = List.castFrom(jsonDecode(response.body));
      return UUIDs;
    } else {
      return [];
    }
  } catch (e) {
    throw HttpException('http call failed: $e');
    return [];
  }
}
