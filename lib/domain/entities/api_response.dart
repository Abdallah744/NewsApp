import 'package:equatable/equatable.dart';
import 'article.dart';

class ApiResponse extends Equatable {
  final String status;
  final int totalResults;
  final List<Article> articles;
  final String? code;
  final String? message;

  const ApiResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
    this.code,
    this.message,
  });

  // Factory method to create an ApiResponse from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final articles = (json['articles'] as List<dynamic>?)
            ?.map((article) => Article.fromJson(article as Map<String, dynamic>))
            .toList() ?? [];

    return ApiResponse(
      status: json['status'] as String? ?? 'error',
      totalResults: json['totalResults'] as int? ?? 0,
      articles: articles,
      code: json['code'] as String?,
      message: json['message'] as String?,
    );
  }

  // Convert ApiResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles.map((article) => article.toJson()).toList(),
      if (code != null) 'code': code,
      if (message != null) 'message': message,
    };
  }

  @override
  List<Object?> get props => [
        status,
        totalResults,
        articles,
        code,
        message,
      ];

  bool get isSuccess => status == 'ok';
}
