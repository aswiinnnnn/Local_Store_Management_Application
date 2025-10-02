# Local Store Management Application

A comprehensive Flutter application designed specifically for tailoring shop management, featuring local database storage, customer data management, income tracking, and advanced visualization capabilities. This app helps small tailoring businesses efficiently manage orders, track customer measurements, monitor income, and maintain detailed records - all offline.

## 📋 Description

This application is built to solve the common challenges faced by tailoring shops in managing customer orders, measurements, and financial records. It provides a complete digital solution for:

- **Customer Data Management**: Store and access customer information, contact details, and addresses
- **Order Tracking**: Create, edit, and monitor tailoring orders with detailed measurements
- **Income Management**: Track payments and visualize income trends with interactive charts
- **Data Export/Import**: Backup and restore data using CSV files
- **Payment Integration**: Generate UPI QR codes for easy payment collection

The app is designed with a focus on **tailoring shop management**, providing specialized measurement forms for different garment types and a streamlined workflow for order processing.

---

## ✨ Features

### 📝 Order Management
- **Create Orders**: Add new tailoring orders with customer details
- **Customer Information**: Store name, contact number, address, and special notes
- **Cloth Type Selection**: Support for Blouse, Churidar, Top, Coat, Shirt, and Pant
- **Detailed Measurements**: Specialized measurement forms for each garment type
- **Bill Number Tracking**: Unique bill numbers for each order
- **Order Status**: Mark orders as completed with payment tracking
- **Edit & Delete**: Full CRUD operations for order management

### 📊 Income Tracking & Analytics
- **Payment Recording**: Record payments when orders are completed
- **Income Statistics**: View total, daily, weekly, and monthly income
- **Interactive Charts**: Visualize income trends with bar charts
- **Date Range Filtering**: Filter income data by custom date ranges
- **Pagination**: Efficient loading of large income datasets
- **Search Functionality**: Search income records by customer name, bill number, or amount

### 🔍 Search & Filtering
- **Advanced Search**: Search orders by customer name, bill number, or cloth type
- **Cloth Type Filtering**: Filter orders by specific garment types
- **Date Range Filtering**: Filter data by custom date ranges
- **Real-time Results**: Instant search results with minimal input

### 📱 User Interface
- **Modern Design**: Clean, intuitive interface with Material Design
- **Responsive Layout**: Adapts to different screen sizes
- **Bottom Navigation**: Easy switching between Orders, Create Order, and Profile
- **Order Details Modal**: Comprehensive order information in bottom sheet
- **Status Indicators**: Visual indicators for completed and pending orders

### 💰 Payment Integration
- **UPI QR Code Generation**: Generate QR codes for UPI payments
- **Hardcoded UPI ID**: Pre-configured UPI ID (customizable in code)
- **Amount Entry**: Enter specific amounts for payment QR codes
- **Payment Tracking**: Link payments to specific orders

### 📁 Data Management
- **CSV Export**: Export orders and income data to CSV files
- **CSV Import**: Import orders and income data from CSV files
- **Data Backup**: Complete data backup and restore functionality
- **Offline Storage**: All data stored locally using Hive database

### 📞 Customer Communication
- **Direct Dial**: Call customers directly from order details
- **Contact Information**: Quick access to customer phone numbers
- **Customer History**: View previous orders for returning customers

### 📈 Analytics & Reporting
- **Income Visualization**: Interactive bar charts for income trends
- **Daily/Weekly/Monthly Views**: Multiple time period analysis
- **Order Statistics**: Track total, completed, and pending orders
- **Performance Metrics**: Monitor business performance over time

---

## 📸 Screenshots

> **Note**: Add screenshots of the following screens to showcase the app's features:
>
> - Main Orders Screen with filter chips
> - Create Order Screen with measurement forms
> - Profile Screen with income charts
> - Order Details Bottom Sheet
> - QR Code Payment Screen
> - Settings/Import-Export Screen
>
> Example structure:
> ```
> ![Orders Screen](screenshots/orders_screen.png)
> ![Create Order](screenshots/create_order.png)
> ![Income Charts](screenshots/income_charts.png)
> ![Order Details](screenshots/order_details.png)
> ![QR Payment](screenshots/qr_payment.png)
> ```

---

## 🛠️ Tech Stack

### Core Framework
- **Flutter**: `^3.8.1` - Cross-platform mobile development framework
- **Dart**: `^3.8.1` - Programming language for Flutter development

### Database & Storage
- **Hive Flutter**: `^1.1.0` - Lightweight, fast local database
- **Hive Generator**: `^2.0.1` - Code generation for Hive type adapters
- **Path Provider**: `^2.1.2` - Access to device file system

### UI & Visualization
- **FL Chart**: `^0.66.2` - Beautiful charts and graphs
- **QR Flutter**: `^4.1.0` - QR code generation
- **Cupertino Icons**: `^1.0.8` - iOS-style icons

### Data Processing
- **CSV**: `^6.0.0` - CSV file parsing and generation
- **File Picker**: `^10.2.0` - File selection for import/export
- **File Selector**: `^1.0.0` - Cross-platform file selection
- **Intl**: `^0.20.2` - Internationalization and date formatting

### System Integration
- **Permission Handler**: `^11.3.1` - Device permissions management
- **URL Launcher**: `^6.2.5` - Launch external URLs and phone dialer

### Development Tools
- **Build Runner**: `^2.1.5` - Code generation runner
- **Flutter Launcher Icons**: `^0.13.1` - App icon generation
- **Flutter Lints**: `^6.0.0` - Linting rules for Flutter

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (version 3.8.1 or higher)
- Dart SDK (version 3.8.1 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/hivelocaldb.git
cd hivelocaldb
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Hive Type Adapters

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the Application

```bash
flutter run
```

### 5. Build for Production

#### Android APK
```bash
flutter build apk --release
```

#### iOS (requires macOS)
```bash
flutter build ios --release
```

---

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point and Hive initialization
├── mainScreen.dart             # Main navigation controller
├── assets/
│   └── icon.png               # App icon
├── components/
│   ├── csv_service.dart       # CSV import/export functionality
│   ├── line_chart_widget.dart # Income visualization charts
│   ├── showOrderDetailsBottomSheet.dart # Order details modal
│   └── measurements/          # Specialized measurement forms
│       ├── blouse_measurements.dart
│       ├── churidar_measurements.dart
│       ├── coat_measurements.dart
│       ├── pant_measurements.dart
│       └── shirt_measurements.dart
├── DB/
│   ├── functions/
│   │   └── db_functions.dart  # Database operations and business logic
│   └── model/
│       └── data_model.dart    # Hive data models (OrderModel, IncomeModel)
└── screens/
    ├── all_orders_scren.dart  # Orders listing with filters
    ├── create_order_screen.dart # Order creation form
    ├── profile_screen.dart    # Income tracking and analytics
    ├── qr_screen.dart         # UPI QR code generation
    └── settings_screen.dart   # Import/export functionality
```

---

## ⚙️ How It Works

### Data Flow
1. **Order Creation**: Users create orders with customer details and measurements
2. **Local Storage**: All data is stored locally using Hive database
3. **Order Management**: Orders can be viewed, edited, and marked as completed
4. **Income Tracking**: When orders are completed, income is recorded and linked
5. **Analytics**: Income data is visualized through interactive charts
6. **Data Export**: Users can backup data using CSV export functionality

### Key Components
- **Hive Database**: Fast, local storage for orders and income data
- **ValueNotifier**: Reactive state management for UI updates
- **Custom Widgets**: Reusable components for measurements and charts
- **Bottom Sheets**: Modal interfaces for order details and actions
- **Charts**: Interactive visualization of income trends

### Offline-First Architecture
- All data is stored locally on the device
- No internet connection required for core functionality
- Data persists between app sessions
- Export/import functionality for data backup

---

## 📱 Usage Guide

### Creating an Order
1. Navigate to "Create Order" tab
2. Enter bill number and customer information
3. Select cloth type from dropdown
4. Fill in measurements based on selected garment type
5. Add any special notes or instructions
6. Tap "Save Order" to create the order

### Managing Orders
1. View all orders in the "Orders" tab
2. Use filter chips to filter by cloth type
3. Tap on any order to view detailed information
4. Edit order details, call customer, or mark as completed
5. Delete orders if needed

### Tracking Income
1. Navigate to "Profile" tab
2. Switch to "Income" view
3. View income statistics and charts
4. Use search and date filters to find specific records
5. Export income data to CSV for external analysis

### Payment Collection
1. Access QR code screen from orders list
2. Enter payment amount (optional)
3. Generate UPI QR code for customer payment
4. Customer scans QR code to make payment

---

## 🔧 Customization

### UPI Configuration
Update the UPI ID in `lib/screens/qr_screen.dart`:
```dart
String upiID = "your-upi-id@bank"; // Replace with your UPI ID
```

### Shop Name
Update shop name in QR code generation:
```dart
"upi://pay?pa=$upiID&pn=YOUR SHOP NAME&am=${amount!.toStringAsFixed(2)}&cu=INR"
```

### Cloth Types
Add or modify cloth types in `lib/screens/create_order_screen.dart`:
```dart
final List<String> clothTypes = [
  'Blouse',
  'Churidar',
  'Top',
  'Coat',
  'Shirt',
  'Pant',
  // Add your custom cloth types here
];
```

### Measurement Forms
Create custom measurement forms in `lib/components/measurements/` directory following the existing pattern.

---

## 📊 Data Models

### OrderModel
```dart
class OrderModel {
  int? id;
  String name;           // Customer name
  String type;           // Cloth type
  String contact;        // Phone number
  String? address;       // Customer address
  String? notes;         // Special instructions
  bool completed;        // Order completion status
  Map<String, String> measurements; // Garment measurements
  DateTime date;         // Order date
  String? billno;        // Bill number
}
```

### IncomeModel
```dart
class IncomeModel {
  int? id;
  int orderId;           // Reference to order
  double amount;         // Payment amount
  DateTime date;         // Payment date
}
```

---

## 🔒 Data Security & Privacy

- **Local Storage**: All data is stored locally on the device
- **No Cloud Sync**: Data never leaves the device unless explicitly exported
- **Permission Management**: App requests only necessary permissions
- **Data Export**: Users control when and how to export their data

---

## ❓ FAQ

### General Questions
**Q: Is the app free to use?**  
A: Yes, this is an open-source application free for personal and commercial use.

**Q: Does the app work offline?**  
A: Yes, the app is designed to work completely offline. No internet connection is required.

**Q: Can I use this for other types of businesses?**  
A: While designed for tailoring shops, the app can be adapted for other service-based businesses with minor modifications.

### Data Management
**Q: What happens to my data if I uninstall the app?**  
A: Data is stored locally and will be lost upon uninstallation. Always export your data before uninstalling.

**Q: How can I backup my data?**  
A: Use the CSV export feature in the Settings screen to backup orders and income data.

**Q: Can I import data from other systems?**  
A: Yes, the app supports CSV import functionality for both orders and income data.

### Technical Questions
**Q: What devices are supported?**  
A: The app supports Android (API 21+) and iOS (12.0+) devices.

**Q: How do I update the app?**  
A: Download the latest version and install it. Your data will be preserved.

**Q: Can I customize the app for my specific needs?**  
A: Yes, the app is open-source and can be modified according to your requirements.

---

## 🤝 Contributing

We welcome contributions to improve this application! Here's how you can help:

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Areas for Contribution
- **UI/UX Improvements**: Better user interface and user experience
- **New Features**: Additional functionality for tailoring shops
- **Bug Fixes**: Report and fix bugs
- **Documentation**: Improve documentation and code comments
- **Testing**: Add unit tests and integration tests
- **Performance**: Optimize app performance and memory usage

### Development Guidelines
- Follow Flutter/Dart coding conventions
- Write meaningful commit messages
- Add comments for complex logic
- Test your changes thoroughly
- Update documentation as needed

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📬 Contact & Support

- **Issues**: Report bugs and request features on [GitHub Issues](https://github.com/yourusername/hivelocaldb/issues)
- **Discussions**: Join discussions on [GitHub Discussions](https://github.com/yourusername/hivelocaldb/discussions)
- **Email**: Contact us at [your-email@example.com](mailto:your-email@example.com)

---

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **Hive**: For the lightweight local database solution
- **FL Chart**: For beautiful chart visualization
- **Open Source Community**: For the various packages that made this project possible

---

## 📈 Roadmap

### Upcoming Features
- [ ] **Multi-language Support**: Support for multiple languages
- [ ] **Cloud Backup**: Optional cloud synchronization
- [ ] **Advanced Analytics**: More detailed business insights
- [ ] **Customer Management**: Enhanced customer relationship features
- [ ] **Inventory Tracking**: Track fabric and material inventory
- [ ] **Appointment Scheduling**: Schedule customer appointments
- [ ] **Receipt Generation**: Generate digital receipts
- [ ] **Expense Tracking**: Track business expenses
- [ ] **Tax Reports**: Generate tax-related reports
- [ ] **Multi-shop Support**: Manage multiple shop locations

### Version History
- **v1.0.0**: Initial release with core functionality
- **v1.1.0**: Added income tracking and charts
- **v1.2.0**: Implemented CSV import/export
- **v1.3.0**: Added UPI QR code generation
- **v1.4.0**: Enhanced search and filtering capabilities

---

**Made with ❤️ for tailoring businesses worldwide**
