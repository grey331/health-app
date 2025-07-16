import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';

class EmergencyCallsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Calls'),
      ),
      body: Consumer<DatabaseService>(
        builder: (context, dbService, child) {
          final emergencyCalls = dbService.emergencyCalls;
          
          if (emergencyCalls.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('No emergency calls'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: emergencyCalls.length,
            itemBuilder: (context, index) {
              final call = emergencyCalls[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(
                    Icons.emergency,
                    color: call.status == 'pending' ? Colors.red : Colors.green,
                  ),
                  title: Text('${call.patientName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(call.description),
                      Text(
                        'Time: ${call.timestamp.toString().substring(0, 16)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (call.responderName != null)
                        Text(
                          'Responder: ${call.responderName}',
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                    ],
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: call.status == 'pending' ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      call.status.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
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
