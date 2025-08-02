import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/data/repositories/news_repository_impl.dart';
import 'package:news_app/domain/repositories/news_repository.dart';
import 'package:news_app/features/news/view_models/news_view_model.dart';
import 'package:provider/provider.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register services
  locator.registerLazySingleton<http.Client>(() => http.Client());
  
  // Register repositories
  locator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(client: locator<http.Client>()),
  );
  
  // Register view models
  locator.registerFactory(
    () => NewsViewModel(newsRepository: locator<NewsRepository>()),
  );
}

// Helper function to get the ViewModel from the context
T getViewModel<T>(BuildContext context, {bool listen = true}) {
  return Provider.of<T>(context, listen: listen);
}
