// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih_1/components/my_button.dart';
import 'package:sih_1/components/my_textfield.dart';
import 'package:sih_1/pages/home_page.dart';
import 'package:sih_1/pages/login_register/forget_password.dart';
import 'models/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    phoneController.dispose();
    passwordContoller.dispose();
    super.dispose();
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });

    // Start animation
    _animationController.forward();

    final phoneNumber = phoneController.text;
    Provider.of<AuthProvider>(context, listen: false).login(phoneNumber);

    // Ensure animation completes before navigating
    await _animationController.reverse().orCancel;

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0); // Slide from right
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void forgotPassword() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ForgotPassword(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0); // Slide from right
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 150),
                Icon(
                  Icons.lock_open_rounded,
                  size: 100,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: phoneController,
                  hintText: "Phone Number",
                  obscureText: false,
                ),
                MyTextField(
                  controller: passwordContoller,
                  hintText: "Password",
                  obscureText: true,
                ),
                GestureDetector(
                  onTap: forgotPassword,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator if _isLoading is true
                    : MyButton(
                        name: 'Sign In',
                        onTap: login,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
