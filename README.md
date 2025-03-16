# Appetite Connect Cashier

A cross-platform desktop cashier application for food ordering systems, built with Flutter. This native desktop app connects to the [Appetite API](https://github.com/nathangtg/appetite-api) backend to provide cashiers and restaurant staff with powerful order management capabilities.

## Features

- **Point of Sale**: Intuitive interface for processing in-person orders
- **Order Management**: View, accept, prepare, and complete orders
- **Menu Management**: Quick access to the restaurant's menu items
- **Order History**: Track past orders with filtering and search capabilities
- **Receipt Generation**: Generate and print customer receipts
- **User Authentication**: Secure login for staff members with role-based access
- **Offline Capability**: Basic functionality when temporarily offline
- **Real-time Updates**: Live order notifications from web and mobile orders
- **Cash Register**: Track daily sales and integrate with payment methods
- **Kitchen Display System**: Send orders to kitchen display for preparation

## Tech Stack

- **Framework**: Flutter 3.4+
- **State Management**: Provider/Bloc pattern
- **API Communication**: HTTP package
- **Local Storage**: Shared Preferences
- **Image Handling**: Image Picker for receipt customization
- **Platform Support**: Windows, macOS, and Linux

## Getting Started

### Prerequisites

- Flutter SDK 3.4.3 or higher
- Dart SDK 3.4.3 or higher
- Appetite API backend running
- Desktop operating system (Windows, macOS, or Linux)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nathangtg/appetite_connect_cashier.git
   cd appetite_connect_cashier
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure API endpoint:
   Create or modify `lib/utils/constants.dart`:
   ```dart
   class ApiConstants {
     static const String baseUrl = 'http://your-api-url.com/api';
   }
   ```

4. Run the application:
   ```bash
   flutter run -d windows  # For Windows
   flutter run -d macos    # For macOS
   flutter run -d linux    # For Linux
   ```

## Key Components

### Authentication System

- Secure login for restaurant staff
- Role-based access control
- Session management and persistence

### Order Management

- View incoming orders (online and in-person)
- Update order status (accepting, preparing, ready, completed)
- Filter and search through orders
- Order details view with customer information

### POS System

- Quick order creation interface
- Menu browsing with categories
- Add items to orders with customization options
- Payment processing (cash, card, etc.)
- Receipt generation and printing

### Reports and Analytics

- Daily sales reports
- Popular items tracking
- Peak hours analysis
- Staff performance metrics

## Deployment

Build the application for your target platform:

```bash
# For Windows
flutter build windows

# For macOS
flutter build macos

# For Linux
flutter build linux
```

The built application will be available in the `build` directory.

## Integration with Appetite API

This application connects to the [Appetite API](https://github.com/nathangtg/appetite-api) for:

- Staff authentication
- Menu data retrieval
- Order management
- Receipt generation
- Sales reporting

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Related Projects

- [Appetite API](https://github.com/nathangtg/appetite-api) - Laravel backend for the Appetite food ordering platform
- [Appetite UI Angular](https://github.com/nathangtg/appetite-ui-angular) - Web interface for customers and restaurant admin
