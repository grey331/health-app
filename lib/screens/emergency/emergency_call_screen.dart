import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import '../../models/user_model.dart';

class EmergencyCallScreen extends StatefulWidget {
  @override
  _EmergencyCallScreenState createState() => _EmergencyCallScreenState();
}

class _EmergencyCallScreenState extends State<EmergencyCallScreen> {
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Call'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is for emergency situations only. Misuse may result in penalties.',
                      style: TextStyle(color: Colors.red[800]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Describe your emergency:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Please describe what kind of help you need...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _makeEmergencyCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emergency),
                          SizedBox(width: 8),
                          Text(
                            'CALL FOR HELP',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your location will be shared with nearby healthcare providers.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeEmergencyCall() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please describe your emergency')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = Provider.of<AuthService>(context, listen: false).currentUser!;
      final locationService = Provider.of<LocationService>(context, listen: false);
      final dbService = Provider.of<DatabaseService>(context, listen: false);

      // Get current location
      await locationService.getCurrentLocation();

      final emergencyCall = EmergencyCall(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: user.id,
        patientName: user.name,
        latitude: locationService.currentLatitude ?? 37.7749,
        longitude: locationService.currentLongitude ?? -122.4194,
        description: _descriptionController.text.trim(),
        timestamp: DateTime.now(),
      );

      await dbService.createEmergencyCall(emergencyCall);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Emergency call sent! Help is on the way.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send emergency call')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
