import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/models/user_profile.dart';
import 'package:timetrack/services/storage_service.dart';
import 'package:timetrack/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final bool isInitialSetup;
  
  const ProfileScreen({
    super.key,
    this.isInitialSetup = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // Load existing profile data if available
    final profile = Provider.of<StorageService>(context, listen: false).userProfile;
    if (profile != null) {
      _usernameController.text = profile.username;
      _displayNameController.text = profile.displayName ?? '';
      _emailController.text = profile.email ?? '';
    }
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final storageService = Provider.of<StorageService>(context, listen: false);
    final profile = UserProfile(
      username: _usernameController.text.trim(),
      displayName: _displayNameController.text.trim().isNotEmpty
          ? _displayNameController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
    );
    
    await storageService.saveUserProfile(profile);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
      
      if (widget.isInitialSetup) {
        Navigator.of(context).pop();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isInitialSetup ? 'Welcome' : 'Profile'),
        automaticallyImplyLeading: !widget.isInitialSetup,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.isInitialSetup) ...[
                  const Icon(
                    Icons.person_pin_circle,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Create Your Profile',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To get started, please enter your username. This will be used to identify your time entries.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
                
                // Username field (required)
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter a unique username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                
                // Display name field (optional)
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name (optional)',
                    hintText: 'How you want to be addressed',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                
                // Email field (optional)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                    hintText: 'Your email address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),
                
                // Save button
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.isInitialSetup ? 'Get Started' : 'Save Profile',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                
                if (!widget.isInitialSetup) ...[
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear All Data'),
                          content: const Text(
                            'This will delete all your time entries and profile information. This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                final storageService = Provider.of<StorageService>(
                                  context,
                                  listen: false,
                                );
                                storageService.clearAllData();
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Return to home
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete Everything'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text(
                      'Clear All Data',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}