import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/providers/auth_provider.dart';
import 'package:fitola/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitolaTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProfileDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(context, user),
                const SizedBox(height: 16),
                
                // Stats Cards
                _buildStatsSection(context, user),
                const SizedBox(height: 16),
                
                // Profile Info
                _buildInfoSection(context, user),
                const SizedBox(height: 16),
                
                // Settings & Actions
                _buildActionsSection(context),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [FitolaTheme.primaryColor, FitolaTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: user.avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      user.avatarUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 50, color: FitolaTheme.primaryColor),
                    ),
                  )
                : const Icon(Icons.person, size: 50, color: FitolaTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          
          // Email
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          
          // Age, Gender
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user.age != null) ...[
                Chip(
                  label: Text('${user.age} years'),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 8),
              ],
              if (user.gender != null)
                Chip(
                  label: Text(user.gender!.toString().split('.').last.toUpperCase()),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              'Height',
              user.height != null ? '${user.height} cm' : 'N/A',
              Icons.height,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'Weight',
              user.weight != null ? '${user.weight} kg' : 'N/A',
              Icons.monitor_weight,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              'BMI',
              user.bmi != null ? user.bmi!.toStringAsFixed(1) : 'N/A',
              Icons.analytics,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: FitolaTheme.primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FitolaTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            if (user.bodyType != null)
              _buildInfoTile(
                context,
                'Body Type',
                user.bodyType!.toString().split('.').last.toUpperCase(),
                Icons.accessibility,
              ),
            if (user.fitnessGoal != null)
              _buildInfoTile(
                context,
                'Fitness Goal',
                user.fitnessGoal!.toString().split('.').last.toUpperCase(),
                Icons.flag,
              ),
            if (user.activityLevel != null)
              _buildInfoTile(
                context,
                'Activity Level',
                user.activityLevel!.toString().split('.').last.toUpperCase(),
                Icons.directions_run,
              ),
            if (user.country != null)
              _buildInfoTile(
                context,
                'Country',
                user.country!,
                Icons.location_on,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: FitolaTheme.primaryColor),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.settings, color: FitolaTheme.primaryColor),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings screen coming soon')),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.history, color: FitolaTheme.secondaryColor),
              title: const Text('Activity History'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to activity history
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Activity history screen coming soon')),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: FitolaTheme.warningColor),
              title: const Text('Achievements'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to achievements
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Achievements screen coming soon')),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.share, color: FitolaTheme.infoColor),
              title: const Text('Share Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Share profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share profile feature coming soon')),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: FitolaTheme.errorColor),
              title: const Text('Logout'),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Edit profile functionality will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: FitolaTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
