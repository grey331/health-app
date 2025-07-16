import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';

class RecordVitalsScreen extends StatefulWidget {
  @override
  _RecordVitalsScreenState createState() => _RecordVitalsScreenState();
}

class _RecordVitalsScreenState extends State<RecordVitalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _oxygenController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedPatientId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Vital Signs'),
      ),
      body: Consumer<DatabaseService>(
        builder: (context, dbService, child) {
          final patients = dbService.getUsersByRole(UserRole.patient);
          
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedPatientId,
                  decoration: InputDecoration(
                    labelText: 'Select Patient',
                    border: OutlineInputBorder(),
                  ),
                  items: patients.map((patient) {
                    return DropdownMenuItem(
                      value: patient.id,
                      child: Text(patient.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPatientId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a patient';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Blood Pressure',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _systolicController,
                        decoration: InputDecoration(
                          labelText: 'Systolic',
                          border: OutlineInputBorder(),
                          suffixText: 'mmHg',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _diastolicController,
                        decoration: InputDecoration(
                          labelText: 'Diastolic',
                          border: OutlineInputBorder(),
                          suffixText: 'mmHg',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _heartRateController,
                  decoration: InputDecoration(
                    labelText: 'Heart Rate',
                    border: OutlineInputBorder(),
                    suffixText: 'bpm',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _temperatureController,
                  decoration: InputDecoration(
                    labelText: 'Temperature',
                    border: OutlineInputBorder(),
                    suffixText: '°F',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _oxygenController,
                  decoration: InputDecoration(
                    labelText: 'Oxygen Saturation',
                    border: OutlineInputBorder(),
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _recordVitals,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Record Vital Signs'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _recordVitals() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = Provider.of<AuthService>(context, listen: false).currentUser!;
      final dbService = Provider.of<DatabaseService>(context, listen: false);

      final vitals = VitalSigns(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: _selectedPatientId!,
        recordedBy: user.name,
        timestamp: DateTime.now(),
        bloodPressureSystolic: _systolicController.text.isNotEmpty 
            ? double.tryParse(_systolicController.text) 
            : null,
        bloodPressureDiastolic: _diastolicController.text.isNotEmpty 
            ? double.tryParse(_diastolicController.text) 
            : null,
        heartRate: _heartRateController.text.isNotEmpty 
            ? double.tryParse(_heartRateController.text) 
            : null,
        temperature: _temperatureController.text.isNotEmpty 
            ? double.tryParse(_temperatureController.text) 
            : null,
        oxygenSaturation: _oxygenController.text.isNotEmpty 
            ? double.tryParse(_oxygenController.text) 
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      await dbService.addVitalSigns(vitals);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vital signs recorded successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to record vital signs')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _temperatureController.dispose();
    _oxygenController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
