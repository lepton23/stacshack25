import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../auth.dart';
import '../../../controllers/firebase_controller.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true; // Track if user wants to login or signup
  String _errorMessage = '';
  List<String> _requests = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Auth().currentUser != null) {
      _loadRequests();
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _errorMessage = '');
    try {
      if (!_isLogin) {
        // Check if user exists before signup
        bool exists = await FirebaseController().userExists(_emailController.text);
        if (exists) {
          setState(() => _errorMessage = 'A user with this email already exists');
          return;
        }
      }
      if (_isLogin) {
        print("Signing in");
        await Auth().signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        // Load requests whenever page opens

      } else {
        await Auth().signUpWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        await FirebaseController().addUser(
          _emailController.text,
        );
      }
      //TODO: ONCE YOU SIGN IN, NAVIGATE TO THE HOME PAGE
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message ?? 'An error occurred');
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _signOut() async {
    try {
      await Auth().signOut();// Force rebuild to show login screen
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _loadRequests() async {
    try {
      print("Loading requests");
      final requests = await FirebaseController().getReceivedRequests(Auth().currentUser!.email!);
      print(requests);
      setState(() => _requests = requests);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //_loadRequests(); // Load requests when user is logged in
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Currently Logged In',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Friend Requests',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        SizedBox( // Fixed height for the ListView
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _requests.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _requests[index],
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () async {
                                        try {
                                          await FirebaseController().acceptFriendRequest(
                                            _requests[index],
                                            Auth().currentUser!.email!,
                                          );
                                          setState(() {
                                            _requests.removeAt(index);
                                          });
                                        } catch (e) {
                                          setState(() => _errorMessage = e.toString());
                                        }
                                      },
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () async {
                                        try {
                                          await FirebaseController().declineFriendRequest(
                                            _requests[index],
                                            Auth().currentUser!.email!,
                                          );
                                          setState(() {
                                            _requests.removeAt(index);
                                          });
                                        } catch (e) {
                                          setState(() => _errorMessage = e.toString());
                                        }
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: Theme.of(context).colorScheme.error,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: _signOut, child: const Text('Sign Out')),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin ? 'Log In' : 'Sign Up',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                if (!_isLogin) Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                if (!_isLogin) const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter password...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isLogin ? 'Log In' : 'Sign Up',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                Text(_isLogin ? 'Don\'t have an account?' : 'Already have an account?'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _toggleAuthMode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isLogin ? 'Sign Up Instead' : 'Log In Instead',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
