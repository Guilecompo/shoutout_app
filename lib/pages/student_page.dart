import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shout_out_app/services/students_firestore.dart';

class StudentPage extends StatefulWidget {
  final String id;
  final String name;
  final String studentId;

  const StudentPage({
    super.key,
    required this.id,
    required this.name,
    required this.studentId,
  });

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage>
    with SingleTickerProviderStateMixin {
  // student firestore
  final firestoreService = FirestoreService();
  // controller
  final TextEditingController _messageController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C6E49),
      body: SafeArea(
        child: Column(
          children: [
            // First Flexible (flex 10)
            Flexible(
              flex: 10,
              child: FadeTransition(
                opacity: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8,
                    color: const Color(0xFF4C956C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  widget.name,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFEFEE3),
                                  ),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.studentId,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFFFEFEE3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Second Flexible (flex 20)
            Flexible(
              flex: 14,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_animation),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      ' ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFEFEE3),
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // Third Flexible (flex 4)
            Flexible(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLength: 150,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(color: Color(0xFF2C6E49)),
                        decoration: InputDecoration(
                          hintText: 'Enter your message',
                          hintStyle: const TextStyle(color: Color(0xFF4C956C)),
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color(0xFFFFA500), width: 2),
                          ),
                          fillColor: const Color(0xFFFEFEE3),
                          filled: true,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        onChanged: (text) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + 0.1 * _animation.value,
                          child: child,
                        );
                      },
                      child: IconButton(
                        icon: const Icon(Icons.send,
                            color: Color(0xFFFFA500), size: 35),
                        onPressed: () {
                          // Handle send button press
                          firestoreService.addMessage(
                            _messageController.text,
                            widget.name,
                          );

                          // Clear textfield
                          _messageController.clear();

                          // Show success dialog
                          _showSuccessDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Success!'),
          content: const Text('Your message has been sent successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
