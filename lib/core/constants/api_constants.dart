class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = '3e53f04a409b43eb8bdd8203daa59c75';
  
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  
  static const Map<String, String> defaultQueryParams = {
    'apiKey': apiKey,
    'language': 'en',
    'pageSize': '20',
  };
}
