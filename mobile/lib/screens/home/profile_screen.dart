import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: FitolaTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: user?.photoUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.photoUrl!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, size: 60),
                                ),
                              )
                            : const Icon(Icons.person, size: 60, color: FitolaTheme.primaryColor),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: FitolaTheme.primaryColor),
                              onPressed: () {
                                // TODO: Implement photo picker
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Photo picker coming soon')),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User Name',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'user@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Stats Row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(context, '24', 'Workouts'),
                  _buildStatColumn(context, '7', 'Streak'),
                  _buildStatColumn(context, '12', 'Buddies'),
                  _buildStatColumn(context, '156', 'Points'),
                ],
              ),
            ),
            
            const Divider(),
            
            // Personal Information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Age Group',
                    user?.ageGroup ?? 'Not set',
                    Icons.cake,
                  ),
                  _buildInfoCard(
                    context,
                    'Gender',
                    user?.gender ?? 'Not set',
                    Icons.person,
                  ),
                  _buildInfoCard(
                    context,
                    'Height',
                    user?.height != null ? '${user!.height} cm' : 'Not set',
                    Icons.height,
                  ),
                  _buildInfoCard(
                    context,
                    'Weight',
                    user?.weight != null ? '${user!.weight} kg' : 'Not set',
                    Icons.monitor_weight,
                  ),
                  _buildInfoCard(
                    context,
                    'BMI',
                    user?.bmi != null 
                        ? '${user!.bmi!.toStringAsFixed(1)} (${user.bmiCategory})'
                        : 'Not calculated',
                    Icons.analytics,
                  ),
                  _buildInfoCard(
                    context,
                    'Body Type',
                    user?.bodyType ?? 'Not set',
                    Icons.accessibility_new,
                  ),
                  _buildInfoCard(
                    context,
                    'City',
                    user?.city ?? 'Not set',
                    Icons.location_city,
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Fitness Goals
            if (user?.goals != null && user!.goals!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fitness Goals',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.goals!.map((goal) {
                        return Chip(
                          label: Text(goal),
                          backgroundColor: FitolaTheme.primaryColor.withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: FitolaTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            
            const Divider(),
            
            // Settings & Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActionTile(
                    context,
                    'Settings',
                    Icons.settings,
                    () {
                      // TODO: Navigate to settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings coming soon')),
                      );
                    },
                  ),
                  _buildActionTile(
                    context,
                    'Privacy',
                    Icons.privacy_tip,
                    () {
                      // TODO: Navigate to privacy settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy settings coming soon')),
                      );
                    },
                  ),
                  _buildActionTile(
                    context,
                    'Help & Support',
                    Icons.help,
                    () {
                      // TODO: Navigate to help
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help & Support coming soon')),
                      );
                    },
                  ),
                  _buildActionTile(
                    context,
                    'Logout',
                    Icons.logout,
                    () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true && mounted) {
                        await authProvider.signOut();
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                        }
                      }
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: FitolaTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: FitolaTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: FitolaTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: FitolaTheme.primaryColor),
        ),
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: FitolaTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : FitolaTheme.primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : null,
            fontWeight: isDestructive ? FontWeight.bold : null,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
