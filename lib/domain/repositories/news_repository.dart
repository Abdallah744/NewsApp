import '../entities/api_response.dart';

abstract class NewsRepository {
  /// Fetches top headlines
  ///
  /// [category] - The category to filter by (e.g., 'business', 'entertainment', 'general', 'health', 'science', 'sports', 'technology')
  /// [country] - The 2-letter ISO 3166-1 code of the country you want to get headlines for
  /// [page] - The page number for pagination
  Future<ApiResponse> getTopHeadlines({
    String? category,
    String? country,
    int page = 1,
  });

  /// Searches for news articles
  ///
  /// [query] - Keywords or phrases to search for in the article title and body
  /// [sortBy] - The order to sort the articles in (relevancy, popularity, publishedAt)
  /// [page] - The page number for pagination
  Future<ApiResponse> searchNews({
    required String query,
    String sortBy = 'publishedAt',
    int page = 1,
  });
}
