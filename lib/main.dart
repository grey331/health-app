import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/location_service.dart';
import 'services/database_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/admin_dashboard.dart';
import 'screens/dashboard/patient_dashboard.dart';
import 'screens/dashboard/doctor_dashboard.dart';
import 'screens/dashboard/nurse_dashboard.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => DatabaseService()),
      ],
      child: MaterialApp(
        title: 'Healthcare App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.currentUser == null) {
          return LoginScreen();
        }
        
        switch (authService.currentUser!.role) {
          case UserRole.admin:
            return AdminDashboard();
          case UserRole.patient:
            return PatientDashboard();
          case UserRole.doctor:
            return DoctorDashboard();
          case UserRole.nurse:
            return NurseDashboard();
          default:
            return LoginScreen();
        }
      },
    );
  }
}
