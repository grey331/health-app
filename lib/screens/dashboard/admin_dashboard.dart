import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';
import '../users/add_user_screen.dart';
import '../users/verify_users_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<DatabaseService>(
        builder: (context, dbService, child) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildStatsGrid(dbService),
                SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildActionButtons(context),
                SizedBox(height: 24),
                Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _buildRecentActivity(dbService),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(DatabaseService dbService) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          'Total Patients',
          dbService.getUsersByRole(UserRole.patient).length.toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          'Total Doctors',
          dbService.getUsersByRole(UserRole.doctor).length.toString(),
          Icons.medical_services,
          Colors.green,
        ),
        _buildStatCard(
          'Total Nurses',
          dbService.getUsersByRole(UserRole.nurse).length.toString(),
          Icons.local_hospital,
          Colors.orange,
        ),
        _buildStatCard(
          'Pending Calls',
          dbService.getPendingCalls().length.toString(),
          Icons.emergency,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddUserScreen()),
                  );
                },
                icon: Icon(Icons.person_add),
                label: Text('Add User'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VerifyUsersScreen()),
                  );
                },
                icon: Icon(Icons.verified_user),
                label: Text('Verify Users'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(DatabaseService dbService) {
    final recentCalls = dbService.emergencyCalls.take(5).toList();
    
    if (recentCalls.isEmpty) {
      return Center(
        child: Text('No recent activity'),
      );
    }

    return ListView.builder(
      itemCount: recentCalls.length,
      itemBuilder: (context, index) {
        final call = recentCalls[index];
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.emergency,
              color: call.status == 'pending' ? Colors.red : Colors.green,
            ),
            title: Text('Emergency Call - ${call.patientName}'),
            subtitle: Text(call.description),
            trailing: Text(
              call.status.toUpperCase(),
              style: TextStyle(
                color: call.status == 'pending' ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
