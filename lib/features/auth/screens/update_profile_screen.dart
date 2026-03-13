import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String _selectedRole = 'STUDENT';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              DropdownButton<String>(
                value: _selectedRole,
                items: ['STUDENT', 'TUTOR'].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }).toList(),
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Hey friend, please implement the API logic here to save the profile
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}