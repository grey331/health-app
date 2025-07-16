import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class DatabaseService extends ChangeNotifier {
  List<User> _users = [];
  List<EmergencyCall> _emergencyCalls = [];
  List<VitalSigns> _vitalSigns = [];

  List<User> get users => _users;
  List<EmergencyCall> get emergencyCalls => _emergencyCalls;
  List<VitalSigns> get vitalSigns => _vitalSigns;

  // Initialize with mock data
  DatabaseService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _users = [
      User(
        id: '1',
        name: 'Admin User',
        email: 'admin@healthcare.com',
        role: UserRole.admin,
      ),
      User(
        id: '2',
        name: 'John Patient',
        email: 'patient@healthcare.com',
        role: UserRole.patient,
        latitude: 37.7749,
        longitude: -122.4194,
      ),
      User(
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
      User(
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
    ];
  }

  Future<void> addUser(User user) async {
    await Future.delayed(Duration(milliseconds: 500));
    _users.add(user);
    notifyListeners();
  }

  Future<void> verifyUser(String userId, bool isVerified) async {
    await Future.delayed(Duration(milliseconds: 500));
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      final user = _users[userIndex];
      _users[userIndex] = User(
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        latitude: user.latitude,
        longitude: user.longitude,
        isVerified: isVerified,
        specialization: user.specialization,
        qualifications: user.qualifications,
        rating: user.rating,
        totalRatings: user.totalRatings,
      );
      notifyListeners();
    }
  }

  Future<void> createEmergencyCall(EmergencyCall call) async {
    await Future.delayed(Duration(milliseconds: 500));
    _emergencyCalls.add(call);
    notifyListeners();
  }

  Future<void> respondToCall(String callId, String responderId, String responderName) async {
    await Future.delayed(Duration(milliseconds: 500));
    final callIndex = _emergencyCalls.indexWhere((call) => call.id == callId);
    if (callIndex != -1) {
      final call = _emergencyCalls[callIndex];
      _emergencyCalls[callIndex] = EmergencyCall(
        id: call.id,
        patientId: call.patientId,
        patientName: call.patientName,
        latitude: call.latitude,
        longitude: call.longitude,
        description: call.description,
        timestamp: call.timestamp,
        status: 'accepted',
        responderId: responderId,
        responderName: responderName,
      );
      notifyListeners();
    }
  }

  Future<void> addVitalSigns(VitalSigns vitals) async {
    await Future.delayed(Duration(milliseconds: 500));
    _vitalSigns.add(vitals);
    notifyListeners();
  }

  List<User> getUsersByRole(UserRole role) {
    return _users.where((user) => user.role == role).toList();
  }

  List<EmergencyCall> getPendingCalls() {
    return _emergencyCalls.where((call) => call.status == 'pending').toList();
  }

  List<VitalSigns> getVitalsByPatient(String patientId) {
    return _vitalSigns.where((vital) => vital.patientId == patientId).toList();
  }
}
