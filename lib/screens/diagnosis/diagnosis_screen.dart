import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _medicationController = TextEditingController();
  final _instructionsController = TextEditingController();
  
  String? _selectedPatientId;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Diagnosis'),
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
                TextFormField(
                  controller: _diagnosisController,
                  decoration: InputDecoration(
                    labelText: 'Diagnosis',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a diagnosis';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _medicationController,
                  decoration: InputDecoration(
                    labelText: 'Prescribed Medication',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _instructionsController,
                  decoration: InputDecoration(
                    labelText: 'Instructions for Patient',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveDiagnosis,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Save Diagnosis'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveDiagnosis() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call to save diagnosis
      await Future.delayed(Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diagnosis saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save diagnosis')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _medicationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}
