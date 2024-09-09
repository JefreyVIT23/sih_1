import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sih_1/pages/welcome/introduction_animation_screen.dart';
import 'package:sih_1/providers/contact_provider.dart';
import 'package:sih_1/providers/profile_provider.dart';
import 'package:sih_1/providers/report_provider.dart';
import 'package:sih_1/providers/sos_provider.dart';
import 'package:sih_1/pages/login_register/models/auth_provider.dart';
// import 'package:sih_1/pages/login_register/login_page.dart';
import 'package:sih_1/providers/theme_provider.dart';
import 'package:sih_1/providers/tracking_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SOSProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider() ),
        ChangeNotifierProvider(create: (context) => ReportIssueProvider() ),
        ChangeNotifierProvider(create: (context) => TrackingProvider() ),
        ChangeNotifierProvider(create: (context) => UserProfileProvider() ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const IntroductionAnimationScreen(),
    );
  }
}
