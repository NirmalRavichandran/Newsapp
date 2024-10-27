
```markdown
# News Headline Application

## Overview
The News Headline Application is a mobile application built with Flutter that fetches the latest news articles from various categories using the NewsAPI. It provides users with a user-friendly interface to read news articles and stay updated with the latest happenings around the world.

## Features
- Displays news articles in a tile view.
- Categories for different types of news (e.g., Technology, Sports, Health).
- Each article can be read in full by tapping 'Read More'.
- User authentication using Flask API.
- Responsive design for various screen sizes.

## Tech Stack
- **Frontend:** Flutter
- **Backend:** Flask (for authentication)
- **Data Source:** NewsAPI
- **Database:** SQLAlchemy

## Getting Started

### Prerequisites
- Flutter SDK installed on your machine.
- An active NewsAPI account for API key.
- Python and flask installed for authentication.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/NirmalRavichandran/news_app.git
   cd news_app
   ```

2. Install the dependencies:
   ```bash
   flutter pub get
   ```

3. Replace the API key in the `lib/home_screen.dart` file:
   ```dart
   const String newsApiKey = 'YOUR_NEWS_API_KEY';
   ```

### Running the App
To run the app in debug mode, use the following command:
```bash
flutter run
```

### Testing
- Test the application on a physical device or emulator.
- Ensure that all functionalities work as expected.


