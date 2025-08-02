import 'package:flutter/material.dart';
import 'package:news_app/app.dart';
import 'package:news_app/core/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator and dependencies
  await setupLocator();
  
  runApp(const NewsApp());
}
