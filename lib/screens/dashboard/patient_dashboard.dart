import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import '../../models/user_model.dart';
import '../emergency/emergency_call_screen.dart';
import '../providers/find_providers_screen.dart';
import '../rating/rate_service_screen.dart';

class PatientDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            _buildQuickActions(context),
            SizedBox(height: 24),
            Text(
              'Nearby Healthcare Providers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _buildNearbyProviders(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EmergencyCallScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.emergency, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FindProvidersScreen()),
                  );
                },
                icon: Icon(Icons.search),
                label: Text('Find Providers'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RateServiceScreen()),
                  );
                },
                icon: Icon(Icons.star),
                label: Text('Rate Service'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNearbyProviders(BuildContext context) {
    return Consumer2<DatabaseService, LocationService>(
      builder: (context, dbService, locationService, child) {
        final doctors = dbService.getUsersByRole(UserRole.doctor);
        final nurses = dbService.getUsersByRole(UserRole.nurse);
        final allProviders = [...doctors, ...nurses];

        if (allProviders.isEmpty) {
          return Center(child: Text('No providers available'));
        }

        return ListView.builder(
          itemCount: allProviders.length,
          itemBuilder: (context, index) {
            final provider = allProviders[index];
            return Card(
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
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(' ${provider.rating.toStringAsFixed(1)} (${provider.totalRatings})'),
                      ],
                    ),
                  ],
                ),
                trailing: provider.isVerified 
                    ? Icon(Icons.verified, color: Colors.green)
                    : Icon(Icons.warning, color: Colors.orange),
              ),
            );
          },
        );
      },
    );
  }
}
