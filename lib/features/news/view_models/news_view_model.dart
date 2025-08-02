// ignore_for_file: prefer_final_fields, unused_field

import 'package:news_app/core/base_view_model.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class NewsViewModel extends BaseViewModel {
  final NewsRepository _newsRepository;
  
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  String? _selectedCategory;
  String? _searchQuery;
  bool _isSearching = false;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

 NewsViewModel({required NewsRepository newsRepository}) 
    : _newsRepository = newsRepository,
      isLoadingMore = false;

  // Getters
  List<Article> get articles => _filteredArticles;
  List<Article> get allArticles => _articles;
  String? get selectedCategory => _selectedCategory;
  bool get isSearching => _isSearching;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  // Categories for the news app
  static const List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  bool isLoadingMore;

  // Initialize the view model
  Future<void> init() async {
    await fetchTopHeadlines();
  }
  
  // Refresh data
  Future<void> refresh() async {
    if (_isSearching && _searchQuery != null) {
      return searchNews(_searchQuery!);
    } else {
      return fetchTopHeadlines(category: _selectedCategory);
    }
  }

  // Fetch top headlines
  Future<void> fetchTopHeadlines({
    String? category,
    bool loadMore = false,
  }) async {
    if (isLoading) return;

    try {
      if (!loadMore) {
        _currentPage = 1;
        _hasMore = true;
        setLoading(true);
      } else {
        _currentPage++;
      }

      _selectedCategory = category;
      _isSearching = false;
      _searchQuery = null;

      final response = await _newsRepository.getTopHeadlines(
        category: category,
        page: _currentPage,
      );

      if (response.isSuccess) {
        if (!loadMore) {
          _articles = response.articles;
        } else {
          _articles.addAll(response.articles);
        }

        _filteredArticles = List.from(_articles);
        _hasMore = response.articles.isNotEmpty && response.articles.length >= 20;
      } else {
        setError(response.message ?? 'Failed to load headlines');
      }
    } catch (e) {
      setError('An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }

  // Search news
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchQuery = null;
      _filteredArticles = List.from(_articles);
      notifyListeners();
      return;
    }

    if (isLoading) return;

    try {
      _currentPage = 1;
      _isSearching = true;
      _searchQuery = query;
      setLoading(true);

      final response = await _newsRepository.searchNews(
        query: query,
        page: _currentPage,
      );

      if (response.isSuccess) {
        _filteredArticles = response.articles;
        _hasMore = response.articles.isNotEmpty && response.articles.length >= 20;
      } else {
        setError(response.message ?? 'Failed to search news');
      }
    } catch (e) {
      setError('An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }

  // Load more search results
  Future<void> loadMoreSearchResults() async {
    if (!_isSearching || _searchQuery == null || !_hasMore || isLoading) return;

    try {
      _currentPage++;
      setLoading(true);

      final response = await _newsRepository.searchNews(
        query: _searchQuery!,
        page: _currentPage,
      );

      if (response.isSuccess) {
        _filteredArticles.addAll(response.articles);
        _hasMore = response.articles.isNotEmpty && response.articles.length >= 20;
        notifyListeners();
      } else {
        _currentPage--; // Revert page number on failure
        setError(response.message ?? 'Failed to load more results');
      }
    } catch (e) {
      _currentPage--; // Revert page number on error
      setError('An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }

  // Load more headlines
  Future<void> loadMoreHeadlines() async {
    if (_isSearching || !_hasMore || isLoading) return;

    try {
      _currentPage++;
      setLoading(true);

      final response = await _newsRepository.getTopHeadlines(
        category: _selectedCategory,
        page: _currentPage,
      );

      if (response.isSuccess) {
        _articles.addAll(response.articles);
        _filteredArticles = List.from(_articles);
        _hasMore = response.articles.isNotEmpty && response.articles.length >= 20;
        notifyListeners();
      } else {
        _currentPage--; // Revert page number on failure
        setError(response.message ?? 'Failed to load more headlines');
      }
    } catch (e) {
      _currentPage--; // Revert page number on error
      setError('An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }

  // Filter articles by category
  void filterByCategory(String? category) {
    if (category == _selectedCategory) return;
    fetchTopHeadlines(category: category);
  }

  // Clear search and show all articles
  void clearSearch() {
    _isSearching = false;
    _searchQuery = null;
    _filteredArticles = List.from(_articles);
    notifyListeners();
  }
}
