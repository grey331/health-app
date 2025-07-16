import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  
  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    // Mock users for demonstration
    final mockUsers = {
      'admin@healthcare.com': User(
        id: '1',
        name: 'Admin User',
        email: 'admin@healthcare.com',
        role: UserRole.admin,
      ),
      'patient@healthcare.com': User(
        id: '2',
        name: 'John Patient',
        email: 'patient@healthcare.com',
        role: UserRole.patient,
        latitude: 37.7749,
        longitude: -122.4194,
      ),
      'doctor@healthcare.com': User(
        id: '3',
        name: 'Dr. Smith',
        email: 'doctor@healthcare.com',
        role: UserRole.doctor,
        latitude: 37.7849,
        longitude: -122.4094,
        isVerified: true,
        specialization: 'Cardiology',
        qualifications: 'MD, FACC',
        rating: 4.8,
        totalRatings: 156,
      ),
      'nurse@healthcare.com': User(
        id: '4',
        name: 'Nurse Johnson',
        email: 'nurse@healthcare.com',
        role: UserRole.nurse,
        latitude: 37.7649,
        longitude: -122.4294,
        isVerified: true,
        qualifications: 'RN, BSN',
        rating: 4.6,
        totalRatings: 89,
      ),
    };

    if (mockUsers.containsKey(email) && password == 'password') {
      _currentUser = mockUsers[email];
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password, UserRole role) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: role,
    );
    
    notifyListeners();
    return true;
  }
}
