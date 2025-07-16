import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';

class RateServiceScreen extends StatefulWidget {
  @override
  _RateServiceScreenState createState() => _RateServiceScreenState();
}

class _RateServiceScreenState extends State<RateServiceScreen> {
  String? _selectedProviderId;
  int _rating = 5;
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Service'),
      ),
      body: Consumer<DatabaseService>(
        builder: (context, dbService, child) {
          final providers = [
            ...dbService.getUsersByRole(UserRole.doctor),
            ...dbService.getUsersByRole(UserRole.nurse),
          ];

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Healthcare Provider',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedProviderId,
                  decoration: InputDecoration(
                    labelText: 'Healthcare Provider',
                    border: OutlineInputBorder(),
                  ),
                  items: providers.map((provider) {
                    return DropdownMenuItem(
                      value: provider.id,
                      child: Text('${provider.name} (${provider.role.toString().split('.').last})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProviderId = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Rating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      icon: Icon(
                        Icons.star,
                        size: 40,
                        color: index < _rating ? Colors.amber : Colors.grey,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 24),
                Text(
                  'Comments (Optional)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Share your experience...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedProviderId == null || _isLoading 
                        ? null 
                        : _submitRating,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Submit Rating'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitRating() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call to submit rating
      await Future.delayed(Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating submitted successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit rating')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
