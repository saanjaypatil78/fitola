import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

class LocationShareScreen extends StatefulWidget {
  const LocationShareScreen({super.key});

  @override
  State<LocationShareScreen> createState() => _LocationShareScreenState();
}

class _LocationShareScreenState extends State<LocationShareScreen> {
  int _selectedDuration = 60; // minutes
  bool _isSharing = false;
  DateTime? _shareEndTime;

  final List<int> _durations = [15, 30, 60, 120, 240]; // minutes

  void _startSharing() {
    setState(() {
      _isSharing = true;
      _shareEndTime = DateTime.now().add(Duration(minutes: _selectedDuration));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location sharing started'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _stopSharing() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Sharing Location?'),
        content: const Text('This will immediately stop sharing your location with others.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSharing = false;
                _shareEndTime = null;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location sharing stopped')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      return '$hours hour${hours > 1 ? 's' : ''}';
    }
  }

  String _getRemainingTime() {
    if (_shareEndTime == null) return '';
    final remaining = _shareEndTime!.difference(DateTime.now());
    if (remaining.isNegative) return '0 min';
    
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours hr ${minutes} min';
    } else {
      return '$minutes min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Location'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: _isSharing 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.grey.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        _isSharing ? Icons.location_on : Icons.location_off,
                        size: 80,
                        color: _isSharing ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isSharing ? 'Location Sharing Active' : 'Not Sharing Location',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _isSharing ? Colors.green : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_isSharing) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Time remaining: ${_getRemainingTime()}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: FitolaTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              if (!_isSharing) ...[
                // Duration Selection
                Text(
                  'Share Duration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _durations.map((duration) {
                    final isSelected = _selectedDuration == duration;
                    return ChoiceChip(
                      label: Text(_formatDuration(duration)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedDuration = duration);
                      },
                      selectedColor: FitolaTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                
                // Privacy Info
                Card(
                  color: Colors.blue.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.security, color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Privacy & Safety',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildPrivacyPoint('Location is only visible to connected FitBuddies'),
                        _buildPrivacyPoint('Sharing automatically stops after selected duration'),
                        _buildPrivacyPoint('You can stop sharing anytime'),
                        _buildPrivacyPoint('Location accuracy: ±50m'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Start Button
                ElevatedButton(
                  onPressed: _startSharing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text(
                        'Start Sharing Location',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Active sharing info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sharing With:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSharingUser('Sarah Johnson', '1.2 km away'),
                        _buildSharingUser('Mike Chen', '2.8 km away'),
                        _buildSharingUser('Emma Davis', '4.5 km away'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Stop Button
                ElevatedButton(
                  onPressed: _stopSharing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stop),
                      SizedBox(width: 8),
                      Text(
                        'Stop Sharing Location',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharingUser(String name, String distance) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: FitolaTheme.primaryColor,
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  distance,
                  style: const TextStyle(
                    fontSize: 12,
                    color: FitolaTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
