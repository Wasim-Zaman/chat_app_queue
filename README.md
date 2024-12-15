# Flutter Chat Application

A modern chat application built with Flutter, featuring both light and dark themes. This project demonstrates clean architecture, state management with Riverpod, and professional API integration.

## Features

### Authentication

- User Sign Up
- User Sign In
- Token-based Authentication
- Auto Token Refresh
- Session Management

### UI/UX

- Light/Dark Theme Support
- Custom Form Components
- Professional Animations
- Loading States
- Error Handling
- Snackbar Notifications
- Page Transitions

### Chat Features

- Real-time Messaging
- Message Types:
  - Text Messages
  - Audio Messages
  - Video Messages
- Online Status
- Message Status (sent, delivered, read)
- Chat History
- User Search

## Tech Stack

### State Management

- flutter_riverpod: ^2.6.1

### Network & Storage

- http: ^1.2.2
- shared_preferences: ^2.3.3

### UI Components

- google_fonts: ^6.2.1
- flutter_svg: ^2.0.10
- page_transition: ^2.1.0

### Development Tools

- logger: ^2.5.0
- freezed: ^2.4.7
- build_runner: ^2.4.8
- json_serializable: ^6.7.1

## Project Structure

lib/
├── components/
│ ├── custom_text_form_field.dart
│ ├── filled_outline_button.dart
│ └── primary_button.dart
├── config/
│ └── app_config.dart
├── models/
│ ├── api_response.dart
│ ├── chat.dart
│ └── chat_message.dart
├── providers/
│ └── auth/
│ ├── auth_provider.dart
│ └── auth_state.dart
├── screens/
│ ├── auth/
│ ├── chats/
│ ├── messages/
│ └── welcome/
├── services/
│ ├── http_service.dart
│ └── storage_service.dart
└── utils/
└── navigation_util.dart

## API Integration

The app uses a RESTful API with:

- Token-based authentication
- Automatic token refresh
- Professional error handling
- Beautiful request/response logging

## Screenshots

[Add your app screenshots here]

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
