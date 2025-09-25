# 🚗 Kanda - AI-Powered Insurance App

A comprehensive Flutter-based insurance management application with Supabase backend integration, featuring AI-driven policy recommendations, claims processing, and marketplace functionality.

## ✨ Features

### 🔐 Authentication & User Management
- **Secure Authentication** - Supabase-powered login/signup with email verification
- **User Profiles** - Complete profile management with photo upload
- **Session Management** - Persistent login sessions with auto-refresh

### 🚙 Vehicle Management
- **Add Vehicles** - Register multiple vehicles with detailed information
- **Vehicle Photos** - Image capture and storage for vehicle documentation
- **Usage Tracking** - Personal, commercial, and ride-share usage categories

### 📋 Policy Management
- **AI Policy Recommendations** - Smart suggestions based on vehicle data and usage patterns
- **Multiple Policy Types** - Comprehensive, third-party, and collision coverage
- **Dynamic Pricing** - Real-time premium calculations with risk assessment
- **Policy Tracking** - Monitor active policies with renewal reminders

### 📝 Claims Processing
- **Digital Claims Submission** - Streamlined claim filing with photo attachments
- **Status Tracking** - Real-time claim status updates
- **Document Management** - Secure document storage and retrieval
- **Automated Workflow** - AI-assisted claim processing

### 🛒 Marketplace Integration
- **Service Discovery** - Browse insurance products and services
- **Provider Directory** - Find and contact service providers
- **Booking System** - Schedule services directly through the app
- **Search & Filters** - Advanced filtering by price, rating, and category

### 🤖 AI-Powered Features
- **Smart Recommendations** - Personalized policy suggestions
- **Risk Assessment** - AI-driven risk evaluation
- **Chatbot Support** - Intelligent customer service
- **Financial Advisory** - AI-powered financial guidance

## 🏗️ Architecture

### Frontend (Flutter)
- **State Management** - StatefulWidget with proper state handling
- **Custom Widgets** - Reusable UI components
- **Navigation** - Named routes with deep linking support
- **Responsive Design** - Adaptive layouts for different screen sizes

### Backend (Supabase)
- **Database** - PostgreSQL with Row Level Security (RLS)
- **Authentication** - Built-in auth with JWT tokens
- **Real-time** - Live data synchronization
- **Storage** - Secure file upload and management

### Database Schema
```sql
-- Core Tables
- user_profiles (user information)
- vehicles (vehicle registration)
- policies (insurance policies)
- claims (insurance claims)
- payment_history (transaction records)
- appointments (scheduled services)
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / VS Code
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/the13nth/kanda.git
   cd kanda
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a new Supabase project
   - Update `lib/services/supabase_config.dart` with your credentials
   - Run the SQL scripts in `sql_updates_only.sql` to set up the database

4. **Configure API Keys**
   - Update `lib/core/config.dart` with your API keys
   - Add your Groq API key for AI features
   - Add your Gemini API key for additional AI capabilities

5. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Key Screens
- **Home Dashboard** - Overview of policies, vehicles, and quick actions
- **Vehicle Registration** - Add new vehicles with photo capture
- **Policy Creation** - AI-recommended policies with dynamic pricing
- **Claims Submission** - Digital claim filing with document upload
- **Marketplace** - Browse and book insurance services

## 🛠️ Development

### Project Structure
```
lib/
├── constants/          # App constants and colors
├── core/              # Core configuration
├── models/            # Data models
├── services/          # Business logic and API calls
├── views/             # UI screens
│   ├── authentication/ # Login/signup screens
│   ├── home/          # Dashboard
│   ├── vehicles/      # Vehicle management
│   ├── policies/      # Policy management
│   ├── claims/        # Claims processing
│   └── marketplace/   # Service marketplace
└── widgets/           # Reusable UI components
```

### Key Dependencies
- `supabase_flutter` - Backend integration
- `image_picker` - Photo capture
- `font_awesome_flutter` - Icons
- `flutter_secure_storage` - Secure storage

## 🔧 Configuration

### Supabase Setup
1. Create a new Supabase project
2. Run the SQL scripts in `sql_updates_only.sql`
3. Update the Supabase URL and anon key in `supabase_config.dart`

### API Keys
- **Groq API** - For AI-powered features
- **Gemini API** - For additional AI capabilities
- Update these in `lib/core/config.dart`

## 📊 Database Schema

### User Management
- `user_profiles` - User information and preferences
- `emergency_contacts` - Emergency contact information

### Vehicle Management
- `vehicles` - Vehicle registration and details
- `vehicle_photos` - Associated vehicle images

### Policy Management
- `policies` - Insurance policy details
- `policy_categories` - Available policy types
- `insurance_companies` - Insurance provider information

### Claims Processing
- `claims` - Insurance claim records
- `claim_attachments` - Associated claim documents

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support, email support@kanda-insurance.com or create an issue in this repository.

## 🔮 Roadmap

- [ ] **Mobile App Store** - Publish to Google Play and App Store
- [ ] **Advanced AI** - Enhanced AI recommendations
- [ ] **Payment Integration** - Stripe/PayPal integration
- [ ] **Push Notifications** - Real-time alerts and reminders
- [ ] **Analytics Dashboard** - Usage analytics and insights
- [ ] **Multi-language Support** - Internationalization
- [ ] **Offline Support** - Offline functionality
- [ ] **API Documentation** - Comprehensive API docs

---

**Built with ❤️ using Flutter & Supabase**
