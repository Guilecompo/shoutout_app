import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shout_out_app/services/firestore.dart';

import 'about.dart'; // Make sure to create this file
import 'admin_page.dart'; // Add this import
import 'student_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _studentIdController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Add this listener to convert text to uppercase
    _studentIdController.addListener(() {
      final String text = _studentIdController.text.toUpperCase();
      _studentIdController.value = _studentIdController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() async {
    String studentId = _studentIdController.text.trim();
    const String adminStudentId = 'PHINMA-COC-CITE';

    if (studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Student ID')),
      );
      return;
    }

    if (studentId == adminStudentId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const AdminPage(), // Make sure to import AdminPage
        ),
      );
      return;
    }

    try {
      DocumentSnapshot? studentDoc =
          await _firestoreService.getStudentByStudentId(studentId);

      if (studentDoc == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student ID not found')),
        );
      } else {
        String id = studentDoc.id;
        Map<String, dynamic> data = studentDoc.data() as Map<String, dynamic>;
        String name = data['name'] ?? 'Unknown';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentPage(
              id: id,
              name: name,
              studentId: studentId,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C6E49),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      'SHOUTOUT',
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFA500),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: FadeTransition(
                opacity: _animation,
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color(0xFF4C956C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'INFORMATION TECHNOLOGY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA500),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'EXHIBIT',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFEFEE3),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Join us for an exciting event! Please log in with your student ID to participate.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFEFEE3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 650),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _studentIdController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: 'Enter Student ID',
                              filled: true,
                              fillColor: const Color(0xFFFEFEE3),
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFF1C1C3C)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA500),
                                foregroundColor: const Color(0xFFFEFEE3),
                                elevation: 5,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15), // Increased vertical padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 18, // Increased font size
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const About()),
          );
        },
        backgroundColor: const Color(0xFFFFA500),
        child: const Icon(Icons.info_outline, color: Color(0xFFFEFEE3)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
