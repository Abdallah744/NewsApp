// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:news_app/core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/domain/entities/article.dart';
import 'package:news_app/features/news/view_models/news_view_model.dart';
import 'package:news_app/features/news/views/article_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late NewsViewModel _viewModel;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = getViewModel<NewsViewModel>(context, listen: false);
    _viewModel.init();
    _scrollController.addListener(_onScroll);
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    
    // Start animation after first frame is rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onArticleTap(Article article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  void _onScroll() {
    if (_isBottom) {
      if (_viewModel.isSearching) {
        _viewModel.loadMoreSearchResults();
      } else {
        _viewModel.loadMoreHeadlines();
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _viewModel.clearSearch();
    } else {
      _viewModel.searchNews(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeProvider.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            'News App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          actions: [
            // Theme Toggle Button
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode 
                    ? Icons.light_mode_rounded 
                    : Icons.dark_mode_rounded,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => themeProvider.toggleTheme(!themeProvider.isDarkMode),
              tooltip: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
            // Refresh Button
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => _viewModel.refresh(),
              tooltip: 'Refresh',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _buildMainContent(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: _onSearch,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search for news...',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 36,
              minWidth: 48,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Consumer<NewsViewModel>(
      builder: (context, viewModel, _) {
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: NewsViewModel.categories.length,
            itemBuilder: (context, index) {
              final category = NewsViewModel.categories[index];
              final isSelected = viewModel.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 12, bottom: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => viewModel.filterByCategory(
                        isSelected ? null : category,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category[0].toUpperCase() + category.substring(1),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onBackground,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 13,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Consumer<NewsViewModel>(
      builder: (context, viewModel, _) {
        // Handle loading state
        if (viewModel.isLoading && viewModel.articles.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (viewModel.error != null && viewModel.articles.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading News',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${viewModel.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => viewModel.refresh(),
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Handle empty state
        if (viewModel.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No articles found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                if (viewModel.isSearching) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Try a different search term',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                  ),
                ],
              ],
            ),
          );
        }

        // Main content with CustomScrollView
        return RefreshIndicator(
          onRefresh: () => viewModel.refresh(),
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildCategoryChips()),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= viewModel.articles.length) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      }
                      final article = viewModel.articles[index];
                      return _buildArticleCard(article, index);
                    },
                    childCount: viewModel.articles.length + (viewModel.isLoading ? 1 : 0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArticleCard(Article article, int index) {
    final publishedAt = article.publishedAt != null
        ? DateFormat('MMM d, y • h:mm a').format(article.publishedAt)
        : '';

    // Calculate delay for staggered animation
    final animationDelay = Duration(milliseconds: 100 + (index % 5) * 100);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _fadeAnimation,
          curve: Interval(
            animationDelay.inMilliseconds / 600,
            1.0,
            curve: Curves.easeOutQuart,
          ),
        )),
        child: _buildArticleCardContent(article, publishedAt),
      ),
    );
  }

  Widget _buildArticleCardContent(Article article, String publishedAt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: () => _onArticleTap(article),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image with Hero Animation
              if (article.urlToImage != null)
                Hero(
                  tag: 'image-${article.heroTag}',
                  child: Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        article.urlToImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_rounded, 
                              size: 40, 
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Article Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source and Date
                    Row(
                      children: [
                        if (article.sourceId != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              article.sourceId!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (article.sourceId != null && publishedAt.isNotEmpty)
                          const SizedBox(width: 8),
                        if (publishedAt.isNotEmpty)
                          Text(
                            publishedAt,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Description
                    if (article.description?.isNotEmpty ?? false)
                      Text(
                        article.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 12),

                    // Read More Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Read More',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
