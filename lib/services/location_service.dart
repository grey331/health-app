import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/user_model.dart';

class LocationService extends ChangeNotifier {
  double? _currentLatitude;
  double? _currentLongitude;
  
  double? get currentLatitude => _currentLatitude;
  double? get currentLongitude => _currentLongitude;

  Future<void> getCurrentLocation() async {
    // Simulate getting current location
    await Future.delayed(Duration(seconds: 1));
    _currentLatitude = 37.7749 + (Random().nextDouble() - 0.5) * 0.01;
    _currentLongitude = -122.4194 + (Random().nextDouble() - 0.5) * 0.01;
    notifyListeners();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  List<User> findNearestProviders(List<User> providers, double userLat, double userLon, {int limit = 5}) {
    if (_currentLatitude == null || _currentLongitude == null) return [];
    
    List<MapEntry<User, double>> providersWithDistance = providers
        .where((provider) => provider.latitude != null && provider.longitude != null)
        .map((provider) => MapEntry(
            provider,
            calculateDistance(userLat, userLon, provider.latitude!, provider.longitude!)))
        .toList();
    
    providersWithDistance.sort((a, b) => a.value.compareTo(b.value));
    
    return providersWithDistance
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }
}
