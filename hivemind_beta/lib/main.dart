import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hivemind_beta/views/screens/comp.dart';
import 'package:hivemind_beta/views/screens/notes_screen.dart';
import 'ar.dart';
import 'package:hivemind_beta/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hivemind_beta/views/screens/firebase_test.dart';
import 'views/widgets/top_bar.dart';
import 'views/widgets/buzz_alert.dart';

// Define color constants
const lightColor = Color(0xFFF8F9FA);
const darkColor = Color(0xFF343A40);
const darkishText = Color(0xFF495057);
const whiteColor = Color(0xFFFFFFFF);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message ${message}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) => {}).onError((err) => {});
  print('User Granted Permission ${settings.authorizationStatus}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiveMind',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkColor,
          primary: darkColor,
          surface: lightColor,
          onSurface: darkishText,
        ),
        textTheme: _buildTextTheme(),
      ),
      home: MyHomePage()
    );
  }

  TextTheme _buildTextTheme() => const TextTheme(
    titleLarge: TextStyle(color: lightColor, fontSize: 48, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: darkishText, fontSize: 48),
    bodyMedium: TextStyle(color: darkishText, fontSize: 24),
    bodySmall: TextStyle(color: darkishText, fontSize: 16),
    labelMedium: TextStyle(color: lightColor, fontSize: 24),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;
  List<Widget> _pages = <Widget>[NotesScreen(), CompassDebug(), ArPage(), FirebaseTest()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Buzzes'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'AR'),
          BottomNavigationBarItem(icon: Icon(Icons.bug_report), label: 'Master Debugger'),
        ],
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        type: BottomNavigationBarType.shifting,
        selectedItemColor: darkColor,
        unselectedItemColor: darkishText.withValues(alpha: 0.6),
        backgroundColor: lightColor,
      ),
    );
  }
}

class ArPage extends StatelessWidget {
  const ArPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HiveMind Beta')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Scaffold(body: ArView())));
          },
          child: const Text('Launch AR View'),
        ),
      ),
    );
  }
}
