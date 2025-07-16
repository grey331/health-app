import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import '../../models/user_model.dart';

class FindProvidersScreen extends StatefulWidget {
  @override
  _FindProvidersScreenState createState() => _FindProvidersScreenState();
}

class _FindProvidersScreenState extends State<FindProvidersScreen> {
  String _selectedFilter = 'all';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Healthcare Providers'),
      ),
      body: Consumer2<DatabaseService, LocationService>(
        builder: (context, dbService, locationService, child) {
          List<User> providers = [];
          
          if (_selectedFilter == 'all') {
            providers = [
              ...dbService.getUsersByRole(UserRole.doctor),
              ...dbService.getUsersByRole(UserRole.nurse),
            ];
          } else if (_selectedFilter == 'doctors') {
            providers = dbService.getUsersByRole(UserRole.doctor);
          } else if (_selectedFilter == 'nurses') {
            providers = dbService.getUsersByRole(UserRole.nurse);
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text('Filter: '),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Providers')),
                          DropdownMenuItem(value: 'doctors', child: Text('Doctors Only')),
                          DropdownMenuItem(value: 'nurses', child: Text('Nurses Only')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: provider.role == UserRole.doctor 
                              ? Colors.green 
                              : Colors.orange,
                          child: Icon(
                            provider.role == UserRole.doctor 
                                ? Icons.medical_services 
                                : Icons.local_hospital,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(provider.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(provider.role == UserRole.doctor ? 'Doctor' : 'Nurse'),
                            if (provider.specialization != null)
                              Text('Specialization: ${provider.specialization}'),
                            if (provider.qualifications != null)
                              Text('Qualifications: ${provider.qualifications}'),
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                Text(' ${provider.rating.toStringAsFixed(1)} (${provider.totalRatings})'),
                                SizedBox(width: 16),
                                if (provider.isVerified)
                                  Row(
                                    children: [
                                      Icon(Icons.verified, size: 16, color: Colors.green),
                                      Text(' Verified', style: TextStyle(color: Colors.green)),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _showContactDialog(context, provider);
                          },
                          child: Text('Contact'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showContactDialog(BuildContext context, User provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${provider.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${provider.email}'),
            SizedBox(height: 8),
            if (provider.specialization != null)
              Text('Specialization: ${provider.specialization}'),
            if (provider.qualifications != null)
              Text('Qualifications: ${provider.qualifications}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Contact request sent to ${provider.name}')),
              );
            },
            child: Text('Send Message'),
          ),
        ],
      ),
    );
  }
}
