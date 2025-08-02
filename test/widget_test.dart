import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/app.dart';
import 'package:news_app/core/service_locator.dart';

void main() {
  testWidgets('App starts up and shows news list', (WidgetTester tester) async {
    // Setup service locator for testing
    setupLocator();
    
    // Build our app and trigger a frame
    await tester.pumpWidget(const NewsApp());
    
    // Verify the app title is shown
    expect(find.text('News App'), findsOneWidget);
    
    // Verify the search bar is present
    expect(find.byType(TextField), findsOneWidget);
    
    // Verify the category chips are present
    expect(find.byType(FilterChip), findsWidgets);
  });
}
