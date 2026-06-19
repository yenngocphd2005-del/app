import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/review_model.dart';
import 'api_service.dart';

class ReviewService {
  static String get baseUrl => ApiService.baseUrl;

  /// GET /api/reviews/product/{productId}?withPhoto=true/false
  static Future<List<ReviewModel>> getReviews(
    String productId, {
    bool withPhoto = false,
  }) async {
    final url = Uri.parse(
      '$baseUrl/reviews/product/$productId${withPhoto ? '?withPhoto=true' : ''}',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => ReviewModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// GET /api/reviews/product/{productId}/summary
  static Future<ReviewSummaryModel> getRatingSummary(String productId) async {
    final url = Uri.parse('$baseUrl/reviews/product/$productId/summary');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ReviewSummaryModel.fromMap(data);
      }
      return ReviewSummaryModel.empty();
    } catch (e) {
      return ReviewSummaryModel.empty();
    }
  }

  /// POST /api/reviews (multipart/form-data)
  static Future<Map<String, dynamic>> submitReview({
    required String productId,
    required String userId,
    required int rating,
    required String comment,
    List<File>? images,
  }) async {
    final url = Uri.parse('$baseUrl/reviews');
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['productId'] = productId;
      request.fields['userId'] = userId;
      request.fields['rating'] = rating.toString();
      request.fields['comment'] = comment;

      if (images != null) {
        for (final image in images) {
          final filename = image.path.split('/').last.split('\\').last;
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            image.path,
            filename: filename,
          ));
        }
      }

      print("PRODUCT ID = $productId");
      print("USER ID = $userId");
      print("RATING = $rating");
      print("COMMENT = $comment");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("REVIEW STATUS = ${response.statusCode}");
      print("REVIEW BODY = ${response.body}");

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      }
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'NETWORK_ERROR: ${e.toString()}',
      };
    }
  }
}
