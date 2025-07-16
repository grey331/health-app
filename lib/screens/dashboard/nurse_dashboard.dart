import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import '../../models/user_model.dart';
import '../emergency/emergency_calls_list.dart';
import '../vitals/record_vitals_screen.dart';
import '../providers/find_providers_screen.dart';

class NurseDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Dashboard'),
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
          final pendingCalls = dbService.getPendingCalls();
          
          return Padding(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Emergency Calls',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (pendingCalls.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${pendingCalls.length}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _buildEmergencyCalls(context, pendingCalls, dbService),
                ),
              ],
            ),
          );
        },
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
                    MaterialPageRoute(builder: (_) => RecordVitalsScreen()),
                  );
                },
                icon: Icon(Icons.monitor_heart),
                label: Text('Record Vitals'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FindProvidersScreen()),
                  );
                },
                icon: Icon(Icons.search),
                label: Text('Find Doctors'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmergencyCalls(BuildContext context, List<EmergencyCall> calls, DatabaseService dbService) {
    if (calls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text('No pending emergency calls'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return Card(
          child: ListTile(
            leading: Icon(Icons.emergency, color: Colors.red),
            title: Text('Emergency - ${call.patientName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(call.description),
                Text(
                  'Time: ${call.timestamp.toString().substring(0, 16)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () async {
                final user = Provider.of<AuthService>(context, listen: false).currentUser!;
                await dbService.respondToCall(call.id, user.id, user.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Responded to emergency call')),
                );
              },
              child: Text('Respond'),
            ),
          ),
        );
      },
    );
  }
}
