import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class About extends StatelessWidget {
  const About({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C6E49),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              _buildProfileCard(
                name: 'Kide Guile Compo',
                imageAsset: 'images/g.jpg',
                portfolioUrl: 'https://guileportfolio.netlify.app/',
              ),
              const SizedBox(height: 20),
              _buildProfileCard(
                name: 'Shadrin Jerome Mopal',
                imageAsset: 'images/s.jpg',
                portfolioUrl: 'https://www.second-example.com',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String name,
    required String imageAsset,
    required String portfolioUrl,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(imageAsset),
            ).animate()
              .fade(duration: 500.ms)
              .scale(delay: 300.ms),
            const SizedBox(height: 15),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ).animate()
              .fadeIn(delay: 300.ms)
              .moveY(begin: 10, end: 0),
            const SizedBox(height: 5),
            Text(
              'Bachelor of Science in Information Technology',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ).animate()
              .fadeIn(delay: 400.ms)
              .moveY(begin: 10, end: 0),
            const SizedBox(height: 5),
            Text(
              'System Developer',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ).animate()
              .fadeIn(delay: 500.ms)
              .moveY(begin: 10, end: 0),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _launchURL(portfolioUrl),
              icon: Icon(Icons.language, color: Colors.yellow[700]),
              label: const Text('Visit Portfolio'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ).animate()
              .fadeIn(delay: 600.ms)
              .scale(delay: 600.ms),
          ],
        ),
      ),
    ).animate()
      .fadeIn()
      .scale(delay: 200.ms);
  }
}
