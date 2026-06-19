import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 10.0.2.2 is the special IP alias for localhost in the Android emulator.
  // Use http://localhost:8080 for web/desktop, or change to your local machine IP for physical devices.
  static const String baseUrl = 'http://192.168.1.6:80/api';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'success': false, 'message': 'NETWORK_ERROR: ${e.toString()}'},
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber ?? '',
        }),
      );

      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'success': false, 'message': 'NETWORK_ERROR: ${e.toString()}'},
      };
    }
  }

  static Future<Map<String, dynamic>> socialLogin(
    String provider,
    String token, {
    bool signUp = false,
  }) async {
    final url = Uri.parse('$baseUrl/auth/social-login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'provider': provider,
          'token': token,
          'signUp': signUp,
        }),
      );

      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'success': false, 'message': 'NETWORK_ERROR: ${e.toString()}'},
      };
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      return {'statusCode': response.statusCode, 'data': data};
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'success': false, 'message': 'NETWORK_ERROR: ${e.toString()}'},
      };
    }
  }

  static Future<List<dynamic>> getProductsByTag(String tag) async {
    final url = Uri.parse('$baseUrl/products/tag/$tag');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getProductsByCategoryId(String categoryId) async {
    final url = Uri.parse('$baseUrl/products/category/$categoryId');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getCategories({String? parentId, bool? root}) async {
    String path = '/categories';
    if (parentId != null) {
      path += '?parentId=$parentId';
    } else if (root == true) {
      path += '?root=true';
    }
    final url = Uri.parse('$baseUrl$path');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print("CATEGORY URL = $url");
      print("CATEGORY STATUS = ${response.statusCode}");
      print("CATEGORY BODY = ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Cannot load products');
  }
}

