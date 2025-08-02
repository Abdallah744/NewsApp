class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'pub_8641e18403e0433abee9f8650a993eb6';
  
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  
  static const Map<String, String> defaultQueryParams = {
    'apiKey': apiKey,
    'language': 'en',
    'pageSize': '20',
  };
}
