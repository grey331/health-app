import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _specializationController = TextEditingController();
  final _qualificationsController = TextEditingController();
  
  UserRole _selectedRole = UserRole.patient;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New User'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: UserRole.values.where((role) => role != UserRole.admin).map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            if (_selectedRole == UserRole.doctor) ...[
              SizedBox(height: 16),
              TextFormField(
                controller: _specializationController,
                decoration: InputDecoration(
                  labelText: 'Specialization',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            if (_selectedRole == UserRole.doctor || _selectedRole == UserRole.nurse) ...[
              SizedBox(height: 16),
              TextFormField(
                controller: _qualificationsController,
                decoration: InputDecoration(
                  labelText: 'Qualifications',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
            SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addUser,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Add User'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dbService = Provider.of<DatabaseService>(context, listen: false);

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole,
        specialization: _selectedRole == UserRole.doctor 
            ? _specializationController.text.trim().isNotEmpty 
                ? _specializationController.text.trim() 
                : null
            : null,
        qualifications: (_selectedRole == UserRole.doctor || _selectedRole == UserRole.nurse)
            ? _qualificationsController.text.trim().isNotEmpty 
                ? _qualificationsController.text.trim() 
                : null
            : null,
      );

      await dbService.addUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add user')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _specializationController.dispose();
    _qualificationsController.dispose();
    super.dispose();
  }
}
