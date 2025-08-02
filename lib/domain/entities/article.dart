import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;
  final String? sourceId;
  final String? sourceName;
  final String heroTag;

  factory Article({
    String? author,
    required String title,
    String? description,
    required String url,
    String? urlToImage,
    required DateTime publishedAt,
    String? content,
    String? sourceId,
    String? sourceName,
    String? heroTag,
  }) {
    return Article._(
      author: author,
      title: title,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      sourceId: sourceId,
      sourceName: sourceName,
      heroTag: heroTag ?? 'article-${DateTime.now().millisecondsSinceEpoch}-${url.hashCode}',
    );
  }
  
  const Article._({
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
    this.sourceId,
    this.sourceName,
    required this.heroTag,
  });

  // Factory method to create an Article from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author: json['author'] as String?,
      title: json['title'] as String? ?? 'No title',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String? ?? DateTime.now().toIso8601String()),
      content: json['content'] as String?,
      sourceId: json['source']?['id'] as String?,
      sourceName: json['source']?['name'] as String?,
    );
  }

  // Convert Article to JSON
  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      'source': {
        'id': sourceId,
        'name': sourceName,
      },
    };
  }

  @override
  List<Object?> get props => [
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
        sourceId,
        sourceName,
        heroTag,
      ];
      
  Article copyWith({
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
    String? sourceId,
    String? sourceName,
    String? heroTag,
  }) {
    return Article(
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      sourceId: sourceId ?? this.sourceId,
      sourceName: sourceName ?? this.sourceName,
      heroTag: heroTag ?? this.heroTag,
    );
  }
}
