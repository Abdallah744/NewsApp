import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/core/constants/api_constants.dart';
import 'package:news_app/domain/entities/api_response.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final http.Client client;
  final String baseUrl;

  NewsRepositoryImpl({
    http.Client? client,
    String? baseUrl,
  })  : client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConstants.baseUrl;

  @override
  Future<ApiResponse> getTopHeadlines({
    String? category,
    String? country = 'us', // Default to US if not specified
    int page = 1,
  }) async {
    try {
      final queryParams = {
        ...ApiConstants.defaultQueryParams,
        'page': page.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
        if (country != null && country.isNotEmpty) 'country': country,
      };

      final uri = Uri.https(
        'newsapi.org',
        '/v2${ApiConstants.topHeadlines}',
        queryParams,
      );

      final response = await client.get(uri);
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(jsonResponse);
      } else {
        return ApiResponse(
          status: 'error',
          totalResults: 0,
          articles: [],
          code: jsonResponse['code']?.toString(),
          message: jsonResponse['message']?.toString() ?? 'Failed to load top headlines',
        );
      }
    } catch (e) {
      return ApiResponse(
        status: 'error',
        totalResults: 0,
        articles: [],
        message: 'An error occurred: $e',
      );
    }
  }

  @override
  Future<ApiResponse> searchNews({
    required String query,
    String sortBy = 'publishedAt',
    int page = 1,
  }) async {
    try {
      if (query.isEmpty) {
        return ApiResponse(
          status: 'error',
          totalResults: 0,
          articles: [],
          message: 'Search query cannot be empty',
        );
      }

      final queryParams = {
        ...ApiConstants.defaultQueryParams,
        'q': query,
        'sortBy': sortBy,
        'page': page.toString(),
      };

      final uri = Uri.https(
        'newsapi.org',
        '/v2${ApiConstants.everything}',
        queryParams,
      );

      final response = await client.get(uri);
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(jsonResponse);
      } else {
        return ApiResponse(
          status: 'error',
          totalResults: 0,
          articles: [],
          code: jsonResponse['code']?.toString(),
          message: jsonResponse['message']?.toString() ?? 'Failed to search news',
        );
      }
    } catch (e) {
      return ApiResponse(
        status: 'error',
        totalResults: 0,
        articles: [],
        message: 'An error occurred: $e',
      );
    }
  }
}
