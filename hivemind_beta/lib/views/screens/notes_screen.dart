import 'package:flutter/material.dart';
import 'dart:math';

import 'package:hivemind_beta/controllers/firebase_controller.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with TickerProviderStateMixin {
  final firebaseController = FirebaseController();

  final TextEditingController _noteController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _animation;
  Future<void>? _sendingFuture;
  bool _isLoading = false;
  
  final List<String> _loadingMessages = [
    'Buzzing your note to the hive...',
    'Honey, we\'re processing your thought...',
    'Bee patient, your idea is taking flight...',
    'Swarming your message to the colony...',
    'Pollinating the network with your insight...',
    'Waxing poetic with your words...',
    'Combing through the data streams...',
    'Your note is causing quite a buzz...',
    'Hive mind activating...',
    'Bee-ing productive with your input...',
  ];

  String get _randomLoadingMessage => _loadingMessages[Random().nextInt(_loadingMessages.length)];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _fadeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _noteController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Leave A Note Here',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _noteController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Write your note here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ScaleTransition(
                        scale: _animation,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_noteController.text.trim().isEmpty) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a note before submitting.'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                                return;
                              }
                              _animationController.forward().then((_) {
                                _animationController.reverse();
                              });
                              if (mounted) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _fadeController.forward();
                              }
                              try {
                                await firebaseController.addMessage(_noteController.text);
                                if (mounted) {
                                  setState(() {
                                    _noteController.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Sent!'),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  await _fadeController.reverse();
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 5,
                            ),
                            child: Text(
                              'Submit Note',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _isLoading ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: _isLoading
                ? Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)),
                          const SizedBox(height: 20),
                          Text(
                            _randomLoadingMessage,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
