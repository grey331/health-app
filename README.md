# Health-App

A comprehensive Flutter application for healthcare management with role-based access control for admins, patients, doctors, and nurses.

## Features

### 🏥 Role-Based Access Control
- **Admin**: Full system access, user management, and verification
- **Patient**: Find providers, emergency calls, service ratings
- **Doctor**: Emergency response, vitals recording, diagnosis, prescriptions
- **Nurse**: Emergency response, vitals recording, doctor consultation

### 🚨 Emergency System
- Real-time emergency calls with location sharing
- Automated provider notifications
- Response tracking and status updates

### 📊 Vital Signs Monitoring
- Blood pressure tracking
- Heart rate monitoring
- Temperature recording
- Oxygen saturation levels
- Comprehensive notes and timestamps

### 🔍 Provider Discovery
- Location-based provider search
- Specialization filtering
- Rating and review system
- Verification status display

### ⭐ Rating & Reviews
- Service quality ratings
- Provider feedback system
- Review management

### 👥 User Management
- Admin-controlled user registration
- Healthcare provider verification
- Qualification validation
- Role assignment

## Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/grey331/health-app.git
   cd health-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Web Deployment

To deploy as a web application:

1. **Build for web**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Vercel**
   ```bash
   cd build/web
   vercel --prod
   ```

## Usage

### Demo Credentials

The app includes demo accounts for testing:

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@healthcare.com | password |
| Patient | patient@healthcare.com | password |
| Doctor | doctor@healthcare.com | password |
| Nurse | nurse@healthcare.com | password |

### Getting Started

1. **Launch the app** and select your role
2. **Login** using the demo credentials
3. **Explore** the dashboard features based on your role
4. **Test** emergency calls, vitals recording, and provider search

### Admin Functions
- Add new users through the "Add User" button
- Verify healthcare providers in the "Verify Users" section
- Monitor system activity and emergency calls
- View user statistics and system overview

### Patient Functions
- Use the red emergency button for urgent help
- Find nearby healthcare providers
- Rate services after appointments
- View provider ratings and qualifications

### Doctor Functions
- Respond to emergency calls from the dashboard
- Record patient vital signs
- Create diagnoses and prescribe medications
- View patient history and records

### Nurse Functions
- Monitor and respond to emergency calls
- Record patient vital signs
- Find nearby doctors for consultation
- Update patient wellbeing status

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── user_model.dart         # Data models
├── services/
│   ├── auth_service.dart       # Authentication logic
│   ├── database_service.dart   # Data management
│   └── location_service.dart   # Location services
├── screens/
│   ├── auth/
│   │   └── login_screen.dart   # Login interface
│   ├── dashboard/
│   │   ├── admin_dashboard.dart
│   │   ├── patient_dashboard.dart
│   │   ├── doctor_dashboard.dart
│   │   └── nurse_dashboard.dart
│   ├── emergency/
│   │   ├── emergency_call_screen.dart
│   │   └── emergency_calls_list.dart
│   ├── vitals/
│   │   └── record_vitals_screen.dart
│   ├── users/
│   │   ├── add_user_screen.dart
│   │   └── verify_users_screen.dart
│   ├── providers/
│   │   └── find_providers_screen.dart
│   ├── rating/
│   │   └── rate_service_screen.dart
│   └── diagnosis/
│       └── diagnosis_screen.dart
```

## Technologies Used

- **Flutter**: UI framework
- **Dart**: Programming language
- **Provider**: State management
- **Material Design**: UI components
- **Location Services**: GPS integration
- **Real-time Updates**: Emergency notifications

## Features in Detail

### Emergency System
- **Instant Response**: One-tap emergency calls
- **Location Sharing**: Automatic GPS coordinates
- **Provider Alerts**: Notify nearby healthcare providers
- **Status Tracking**: Real-time emergency status updates

### Vital Signs Management
- **Comprehensive Monitoring**: Multiple vital sign parameters
- **Historical Tracking**: Timeline of patient measurements
- **Provider Access**: Shared access for doctors and nurses
- **Data Validation**: Input validation and error handling

### User Verification
- **Credential Verification**: Admin approval for healthcare providers
- **Qualification Validation**: Document and certificate verification
- **Role Management**: Secure role-based access control
- **Account Security**: Protected user authentication

### Provider Discovery
- **Proximity Search**: Find nearest healthcare providers
- **Specialization Filter**: Filter by medical specialization
- **Rating System**: User ratings and reviews
- **Availability Status**: Real-time provider availability

## Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Development Guidelines
- Follow Flutter best practices
- Write clear, documented code
- Test all new features
- Maintain consistent code style
- Update documentation as needed

## Testing

### Running Tests
```bash
flutter test
```

### Test Coverage
- Unit tests for services
- Widget tests for UI components
- Integration tests for user flows

## Deployment

### Web Deployment
1. Build the web version
2. Deploy to Vercel, Netlify, or Firebase Hosting
3. Configure environment variables

### Mobile Deployment
1. Build for Android/iOS
2. Deploy to Google Play Store / Apple App Store
3. Configure app signing and certificates

## Future Enhancements

- [ ] Real-time chat between providers and patients
- [ ] Appointment scheduling system
- [ ] Medication reminders
- [ ] Health analytics and reports
- [ ] Integration with wearable devices
- [ ] Telemedicine video calls
- [ ] Electronic health records (EHR)
- [ ] Insurance integration
- [ ] Multi-language support
- [ ] Offline functionality

## Security

- Role-based access control
- Secure authentication
- Data encryption
- HIPAA compliance considerations
- Privacy protection measures

## Support

For support and questions:
- Create an issue on GitHub
- Email: joycegrace331@gmail.com

**Note**: This is a demo application for educational purposes. For production use, implement proper security measures, real backend integration, and compliance with healthcare regulations.
```
