// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:permission_handler/permission_handler.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),  // Pass context here
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildLocationInfo(),
                    Expanded(child: _buildPlaceholder(context)),
                    _buildAlertButtons(),
                    _buildBottomButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modified Header to Properly Handle User Authentication State
  Widget _buildHeader(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo.png', height: 50),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                child: Column(
                  children: [
                    const Icon(Icons.account_circle, color: Color(0xFF57D463), size: 30),
                    const SizedBox(height: 4),
                    Text(
                      user != null
                          ? (user.displayName ?? user.email ?? 'User')
                          : 'Guest',
                      style: const TextStyle(color: Color(0xFF57D463), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Location Info Widget
  Widget _buildLocationInfo() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are in Trujillo, Peru',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF57D463)),
          ),
          Text(
            'This is happening in your area',
            style: TextStyle(fontSize: 18, color: Color(0xFF57D463)),
          ),
        ],
      ),
    );
  }

  // Placeholder for Map or Content
  Widget _buildPlaceholder(BuildContext context) {
    // Placeholder widget in place of Google Map
    return const SizedBox(
      height: 300,
      child: Center(
        child: Text(
          'Map Placeholder',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }

  // Alert Buttons (Fire, Crash, Theft, Dog Alerts)
  Widget _buildAlertButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildAlertButton('Fire Alert', Colors.orange, 'assets/images/fire.png')),
              const SizedBox(width: 8),
              Expanded(child: _buildAlertButton('Crash Alert', Colors.blue, 'assets/images/car.png')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildAlertButton('Theft Alert', Colors.red, 'assets/images/theft.png')),
              const SizedBox(width: 8),
              Expanded(child: _buildAlertButton('Dog Alert', Colors.green, 'assets/images/dog.png')),
            ],
          ),
        ],
      ),
    );
  }

  // Alert Button Widget
  Widget _buildAlertButton(String text, Color color, String iconPath) {
    return ElevatedButton(
      onPressed: () {
        // Implement alert functionality
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 24, width: 24),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Bottom Buttons (Call Emergencies, Chatbot)
  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                // Format the phone number with proper URI encoding
                final phoneNumber = Uri.encodeFull('911');
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );

                // Check for permission status
                var status = await Permission.phone.status;
                
                if (status.isGranted) {
                  try {
                    // Use launchUrl with specific launch mode for phone calls
                    await url_launcher.launchUrl(
                      launchUri,
                      mode: url_launcher.LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error launching dialer: ${e.toString()}')),
                      );
                    }
                  }
                } else {
                  // Request permission if not granted
                  var result = await Permission.phone.request();
                  
                  if (result.isGranted) {
                    try {
                      await url_launcher.launchUrl(
                        launchUri,
                        mode: url_launcher.LaunchMode.externalApplication,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error launching dialer: ${e.toString()}')),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Permission denied to make calls')),
                      );
                    }
                  }
                }
              },
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text('CALL EMERGENCIES', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            alignment: Alignment.topLeft,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Implement chatbot functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                ),
                child: Image.asset('assets/images/bot.png', height: 40, width: 40),
              ),
              Positioned(
                top: -5,
                left: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat, size: 20, color: Color(0xFF57D463)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
