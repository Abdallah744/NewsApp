# 📰 News App

A modern, responsive Flutter application that delivers the latest news from various categories. Built with clean architecture and MVVM pattern, this app provides a seamless news browsing experience with smooth animations and a beautiful UI.

## ✨ Features

- **Latest News**: Stay updated with current headlines from various categories
- **Category Filtering**: Filter news by categories like Business, Technology, Sports, etc.
- **Search Functionality**: Find specific news articles with the powerful search feature
- **Dark/Light Theme**: Toggle between light and dark themes for comfortable reading
- **Responsive Design**: Optimized for different screen sizes and orientations
- **Pull-to-Refresh**: Easily refresh the news feed
- **Infinite Scroll**: Load more articles as you scroll
- **Article Details**: View full article details with a beautiful transition
- **Smooth Animations**: Enjoy fluid animations and transitions

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- An IDE (Android Studio, VS Code, or IntelliJ IDEA)
- An API key from [NewsAPI](https://newsapi.org/)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/news_app.git
   cd news_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the root directory and add your NewsAPI key:
   ```
   NEWS_API_KEY=your_api_key_here
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   └── repositories/
├── domain/
│   └── entities/
└── features/
    └── news/
        ├── views/
        └── view_models/
```

## 🛠️ Built With

- [Flutter](https://flutter.dev/) - Beautiful native apps in record time
- [Dart](https://dart.dev/) - Client-optimized language for fast apps
- [Provider](https://pub.dev/packages/provider) - State management
- [http](https://pub.dev/packages/http) - For making HTTP requests
- [intl](https://pub.dev/packages/intl) - Internationalization and localization
- [shared_preferences](https://pub.dev/packages/shared_preferences) - For storing user preferences

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [NewsAPI](https://newsapi.org/) for providing the news data
- Flutter community for awesome packages and resources
