// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih_1/components/my_button.dart';
import 'package:sih_1/components/my_textfield.dart';
import 'package:sih_1/pages/home_page.dart';
// import 'package:sih_1/pages/login_register/login_page.dart';
import 'models/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();
  final TextEditingController confirmpasswordContoller = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isLoading = false; // State to manage loading indicator visibility

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
    nameController.dispose();
    passwordContoller.dispose();
    confirmpasswordContoller.dispose();
    super.dispose();
  }

  void register() async {
    if (passwordContoller.text == confirmpasswordContoller.text) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Start animation
      _animationController.forward();

      final phoneNumber = phoneController.text;
      Provider.of<AuthProvider>(context, listen: false).register(phoneNumber);

      // Simulate a delay to show animation progress
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false; // Hide loading indicator
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
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords don\'t match'),
        ),
      );
    }
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
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),
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
                MyTextField(
                  controller: confirmpasswordContoller,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator if _isLoading is true
                    : MyButton(
                        name: 'Sign Up',
                        onTap: register,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
