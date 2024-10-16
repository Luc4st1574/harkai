import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
                    Expanded(child: _buildMap()),
                    _buildAlertButtons(),
                    _buildBottomButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', height: 50),
          const Row(
            children: [
              Icon(Icons.account_circle, color: Color(0xFF57D463), size: 30),
              SizedBox(width: 8),
              Text('Lucas', style: TextStyle(color: Color(0xFF57D463), fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

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

  Widget _buildMap() {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-8.1116, -79.0289), // Coordinates for Trujillo, Peru
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('user_location'),
            position: const LatLng(-8.1116, -79.0289),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        },
      ),
    );
  }

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

  Widget _buildAlertButton(String text, Color color, String iconPath) {
    return ElevatedButton(
      onPressed: () {},
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

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
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
                onPressed: () {},
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