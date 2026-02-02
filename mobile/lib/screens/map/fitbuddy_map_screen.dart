import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/providers/map_provider.dart';
import 'package:fitola/providers/status_provider.dart';

class FitbuddyMapScreen extends StatefulWidget {
  const FitbuddyMapScreen({super.key});

  @override
  State<FitbuddyMapScreen> createState() => _FitbuddyMapScreenState();
}

class _FitbuddyMapScreenState extends State<FitbuddyMapScreen> {
  double _radiusKm = 10.0;
  bool _isLoading = false;

  // Mock nearby users
  final List<Map<String, dynamic>> _nearbyUsers = [
    {
      'id': 'user1',
      'name': 'Sarah Johnson',
      'distance': 1.2,
      'status': 'Available',
      'goals': ['Weight Loss', 'Running'],
      'lastActive': '5 min ago',
    },
    {
      'id': 'user2',
      'name': 'Mike Chen',
      'distance': 2.8,
      'status': 'Available',
      'goals': ['Muscle Gain', 'Weightlifting'],
      'lastActive': '10 min ago',
    },
    {
      'id': 'user3',
      'name': 'Emma Davis',
      'distance': 4.5,
      'status': 'Busy',
      'goals': ['Flexibility', 'Yoga'],
      'lastActive': '1 hour ago',
    },
    {
      'id': 'user4',
      'name': 'John Smith',
      'distance': 7.2,
      'status': 'Available',
      'goals': ['General Fitness', 'Cardio'],
      'lastActive': '30 min ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadNearbyUsers();
  }

  Future<void> _loadNearbyUsers() async {
    setState(() => _isLoading = true);
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final statusProvider = context.watch<StatusProvider>();
    final isGhostMode = statusProvider.status == 'Ghost';

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitBuddy Map'),
        elevation: 0,
        actions: [
          // Ghost Mode Toggle
          IconButton(
            icon: Icon(isGhostMode ? Icons.visibility_off : Icons.visibility),
            color: isGhostMode ? Colors.grey : Colors.green,
            onPressed: () {
              final newStatus = isGhostMode ? 'Available' : 'Ghost';
              statusProvider.setStatus(newStatus);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isGhostMode
                        ? 'You are now visible on the map'
                        : 'Ghost mode enabled - You are hidden from the map',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Placeholder
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Interactive Map View',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'OpenStreetMap integration',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Radius Selector
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search Radius: ${_radiusKm.toStringAsFixed(1)} km',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Slider(
                              value: _radiusKm,
                              min: 1,
                              max: 50,
                              divisions: 49,
                              label: '${_radiusKm.toStringAsFixed(1)} km',
                              onChanged: (value) {
                                setState(() => _radiusKm = value);
                              },
                              onChangeEnd: (value) => _loadNearbyUsers(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Status Banner
                  if (isGhostMode)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.grey[800],
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility_off, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Ghost Mode Active - You are hidden from other users',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Nearby Users List
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nearby FitBuddies (${_nearbyUsers.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _loadNearbyUsers,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _nearbyUsers.length,
                          itemBuilder: (context, index) {
                            final user = _nearbyUsers[index];
                            return _buildUserCard(user);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Centering on your location...')),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isAvailable = user['status'] == 'Available';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: FitolaTheme.primaryColor,
              child: Text(
                user['name'][0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: FitolaTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 14, color: FitolaTheme.primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    '${user['distance']} km',
                    style: const TextStyle(
                      fontSize: 12,
                      color: FitolaTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: (user['goals'] as List<String>).map((goal) {
                return Chip(
                  label: Text(goal),
                  labelStyle: const TextStyle(fontSize: 10),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              'Last active: ${user['lastActive']}',
              style: const TextStyle(fontSize: 12, color: FitolaTheme.textSecondary),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat),
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.chatDetail,
              arguments: {
                'userId': user['id'],
                'userName': user['name'],
              },
            );
          },
        ),
        isThreeLine: true,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter FitBuddies'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Available Only'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Same Goals'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Similar Fitness Level'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadNearbyUsers();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
