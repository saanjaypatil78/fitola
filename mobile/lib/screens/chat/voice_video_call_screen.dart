import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

class VoiceVideoCallScreen extends StatefulWidget {
  const VoiceVideoCallScreen({super.key});

  @override
  State<VoiceVideoCallScreen> createState() => _VoiceVideoCallScreenState();
}

class _VoiceVideoCallScreenState extends State<VoiceVideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = false;
  String _callDuration = '00:00';

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  void _startCallTimer() {
    // Simulate call duration timer
    int seconds = 0;
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        seconds++;
        final minutes = seconds ~/ 60;
        final secs = seconds % 60;
        setState(() {
          _callDuration = '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        });
        _startCallTimer();
      }
    });
  }

  void _endCall() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userName = args?['userName'] ?? 'User';
    final isVideoCall = args?['isVideo'] ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video/Voice Call Background
            if (isVideoCall)
              Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.videocam,
                    size: 100,
                    color: Colors.white38,
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      FitolaTheme.primaryColor.withOpacity(0.8),
                      FitolaTheme.primaryColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white24,
                        child: Text(
                          userName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _callDuration,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Top Bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          isVideoCall ? 'Video Call' : 'Voice Call',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: () {
                      // Toggle fullscreen
                    },
                  ),
                ],
              ),
            ),
            
            // Control Buttons
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mute Button
                      _buildControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: _isMuted ? 'Unmute' : 'Mute',
                        onPressed: () {
                          setState(() {
                            _isMuted = !_isMuted;
                          });
                        },
                        color: _isMuted ? Colors.red : Colors.white24,
                      ),
                      
                      // Speaker Button
                      _buildControlButton(
                        icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                        label: 'Speaker',
                        onPressed: () {
                          setState(() {
                            _isSpeakerOn = !_isSpeakerOn;
                          });
                        },
                        color: Colors.white24,
                      ),
                      
                      // Camera Button (Video only)
                      if (isVideoCall)
                        _buildControlButton(
                          icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
                          label: _isCameraOff ? 'Camera Off' : 'Camera On',
                          onPressed: () {
                            setState(() {
                              _isCameraOff = !_isCameraOff;
                            });
                          },
                          color: _isCameraOff ? Colors.red : Colors.white24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // End Call Button
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.call_end, size: 32),
                      color: Colors.white,
                      onPressed: _endCall,
                      padding: const EdgeInsets.all(20),
                    ),
                  ),
                ],
              ),
            ),
            
            // Self Video Preview (for video calls)
            if (isVideoCall)
              Positioned(
                top: 100,
                right: 16,
                child: Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: 28),
            color: Colors.white,
            onPressed: onPressed,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
