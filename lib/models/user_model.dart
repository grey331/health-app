enum UserRole { admin, patient, doctor, nurse }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final double? latitude;
  final double? longitude;
  final bool isVerified;
  final String? specialization;
  final String? qualifications;
  final double rating;
  final int totalRatings;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.latitude,
    this.longitude,
    this.isVerified = false,
    this.specialization,
    this.qualifications,
    this.rating = 0.0,
    this.totalRatings = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere((e) => e.toString() == json['role']),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isVerified: json['isVerified'] ?? false,
      specialization: json['specialization'],
      qualifications: json['qualifications'],
      rating: json['rating']?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'isVerified': isVerified,
      'specialization': specialization,
      'qualifications': qualifications,
      'rating': rating,
      'totalRatings': totalRatings,
    };
  }
}

class EmergencyCall {
  final String id;
  final String patientId;
  final String patientName;
  final double latitude;
  final double longitude;
  final String description;
  final DateTime timestamp;
  final String status; // pending, accepted, completed
  final String? responderId;
  final String? responderName;

  EmergencyCall({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.timestamp,
    this.status = 'pending',
    this.responderId,
    this.responderName,
  });

  factory EmergencyCall.fromJson(Map<String, dynamic> json) {
    return EmergencyCall(
      id: json['id'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'] ?? 'pending',
      responderId: json['responderId'],
      responderName: json['responderName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'responderId': responderId,
      'responderName': responderName,
    };
  }
}

class VitalSigns {
  final String id;
  final String patientId;
  final String recordedBy;
  final DateTime timestamp;
  final double? bloodPressureSystolic;
  final double? bloodPressureDiastolic;
  final double? heartRate;
  final double? temperature;
  final double? oxygenSaturation;
  final String? notes;

  VitalSigns({
    required this.id,
    required this.patientId,
    required this.recordedBy,
    required this.timestamp,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.oxygenSaturation,
    this.notes,
  });

  factory VitalSigns.fromJson(Map<String, dynamic> json) {
    return VitalSigns(
      id: json['id'],
      patientId: json['patientId'],
      recordedBy: json['recordedBy'],
      timestamp: DateTime.parse(json['timestamp']),
      bloodPressureSystolic: json['bloodPressureSystolic']?.toDouble(),
      bloodPressureDiastolic: json['bloodPressureDiastolic']?.toDouble(),
      heartRate: json['heartRate']?.toDouble(),
      temperature: json['temperature']?.toDouble(),
      oxygenSaturation: json['oxygenSaturation']?.toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'recordedBy': recordedBy,
      'timestamp': timestamp.toIso8601String(),
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'heartRate': heartRate,
      'temperature': temperature,
      'oxygenSaturation': oxygenSaturation,
      'notes': notes,
    };
  }
}
