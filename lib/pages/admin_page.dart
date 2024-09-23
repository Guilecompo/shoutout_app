import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shout_out_app/services/students_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  final firestoreService = FirestoreService();
  DocumentSnapshot? randomShoutout;
  Timer? refreshTimer;
  late AnimationController _listAnimationController;
  late AnimationController _randomShoutoutController;
  late Animation<double> _randomShoutoutAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    refreshRandomShoutout();
    refreshTimer = Timer.periodic(
        const Duration(seconds: 15), (_) => refreshRandomShoutout());
    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _randomShoutoutController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _randomShoutoutAnimation = CurvedAnimation(
      parent: _randomShoutoutController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    _randomShoutoutController.dispose();
    refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void refreshRandomShoutout() {
    firestoreService.getMessageStream().first.then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _randomShoutoutController.reverse().then((_) {
          setState(() {
            randomShoutout =
                snapshot.docs[Random().nextInt(snapshot.docs.length)];
          });
          _randomShoutoutController.forward();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C6E49),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // First column (70% of screen width)
                SizedBox(
                  width: constraints.maxWidth * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2C6E49), Color(0xFF4C956C)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2C6E49).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Center(
                            child: Text(
                              'PHINMA',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Cagayan de Oro College  ',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'I.T EXHIBIT 2024',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedTextKit(
                                      animatedTexts: [
                                        WavyAnimatedText(
                                          'RANDOM SHOUTOUT',
                                          textStyle: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFA500),
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                      isRepeatingAnimation: true,
                                      repeatForever: true,
                                    ),
                                    const SizedBox(height: 24),
                                    Expanded(
                                      child: Center(
                                        child: randomShoutout != null
                                            ? FadeTransition(
                                                opacity:
                                                    _randomShoutoutAnimation,
                                                child: SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin: const Offset(0, 0.1),
                                                    end: Offset.zero,
                                                  ).animate(
                                                      _randomShoutoutAnimation),
                                                  child: ShoutoutListTile(
                                                    shoutout: randomShoutout!,
                                                  ),
                                                ),
                                              )
                                            : const Text(
                                                'No Shoutouts Available',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Second column (30% of screen width)
                SizedBox(
                  width: constraints.maxWidth * 0.3,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getMessageStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List messageList = snapshot.data!.docs;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = messageList[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            String nameText = data['name'];
                            String messageText = data['message'];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4C956C),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4C956C)
                                        .withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FROM: $nameText',
                                      style: const TextStyle(
                                        color: Color(0xFFFEFEE3),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      messageText,
                                      style: const TextStyle(
                                        color: Color(0xFFFEFEE3),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text('No Shoutouts...',
                                style: TextStyle(color: Color(0xFFFEFEE3))));
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ShoutoutListTile extends StatefulWidget {
  final DocumentSnapshot shoutout;

  const ShoutoutListTile({super.key, required this.shoutout});

  @override
  State<ShoutoutListTile> createState() => _ShoutoutListTileState();
}

class _ShoutoutListTileState extends State<ShoutoutListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.shoutout.data() as Map<String, dynamic>;
    String nameText = data['name'];
    String messageText = data['message'];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4C956C), Color(0xFF2C6E49)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4C956C).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FROM: $nameText',
                    style: const TextStyle(
                      color: Color(0xFFFEFEE3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    messageText,
                    style: const TextStyle(
                      color: Color(0xFFFEFEE3),
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
