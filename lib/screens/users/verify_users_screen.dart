import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';

class VerifyUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Users'),
      ),
      body: Consumer<DatabaseService>(
        builder: (context, dbService, child) {
          final unverifiedUsers = dbService.users
              .where((user) => 
                  (user.role == UserRole.doctor || user.role == UserRole.nurse) && 
                  !user.isVerified)
              .toList();

          if (unverifiedUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('All users are verified'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: unverifiedUsers.length,
            itemBuilder: (context, index) {
              final user = unverifiedUsers[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.role == UserRole.doctor 
                        ? Colors.green 
                        : Colors.orange,
                    child: Icon(
                      user.role == UserRole.doctor 
                          ? Icons.medical_services 
                          : Icons.local_hospital,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      Text('Role: ${user.role.toString().split('.').last.toUpperCase()}'),
                      if (user.specialization != null)
                        Text('Specialization: ${user.specialization}'),
                      if (user.qualifications != null)
                        Text('Qualifications: ${user.qualifications}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await dbService.verifyUser(user.id, false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User rejected')),
                          );
                        },
                        icon: Icon(Icons.close, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () async {
                          await dbService.verifyUser(user.id, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User verified successfully')),
                          );
                        },
                        icon: Icon(Icons.check, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
