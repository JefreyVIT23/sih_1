// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sih_1/providers/contact_provider.dart';
import 'package:telephony/telephony.dart';
import 'package:torch_light/torch_light.dart';

class SOS2 extends StatefulWidget {
  const SOS2({super.key});
  @override
  _SOS2State createState() => _SOS2State();
}

class _SOS2State extends State<SOS2> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  int countdown = 3; // Countdown starts from 3 seconds
  late Timer _timer;
  final String morseCode = "... --- ..."; // Morse code for SOS
  final int dotDuration = 200; // Duration for '.' in milliseconds
  final int dashDuration = 600; // Duration for '-' in milliseconds
  final int gapDuration = 200; // Gap between signals in milliseconds
  final int charGapDuration = 600; // Gap between characters in milliseconds

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    // Start the countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (countdown == 0) {
        timer.cancel();
        // Trigger emergency call or action
        handleSOS();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }
  Future<void> _checkAndRequestPermission() async {
    // Check camera permission status
    PermissionStatus status = await Permission.camera.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      // Request permission if not already granted
      status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required to use the flashlight')),
        );
        return;
      }
    }
    
    // If permission is granted, proceed to flash Morse code
    _flashMorseCode();
  }

  Future<void> _turnOnFlashlight() async {
    try {
      await TorchLight.enableTorch();
    } catch (e) {
      print('Could not turn on flashlight: $e');
    }
  }

  Future<void> _turnOffFlashlight() async {
    try {
      await TorchLight.disableTorch();
    } catch (e) {
      print('Could not turn off flashlight: $e');
    }
  }
  Future<void> _flashMorseCode() async {
    for (int i = 0; i < morseCode.length; i++) {
      if (morseCode[i] == '.') {
        await _turnOnFlashlight();
        await Future.delayed(Duration(milliseconds: dotDuration));
      } else if (morseCode[i] == '-') {
        await _turnOnFlashlight();
        await Future.delayed(Duration(milliseconds: dashDuration));
      } else {
        await Future.delayed(Duration(milliseconds: charGapDuration));
        continue;
      }
      await _turnOffFlashlight();
      await Future.delayed(Duration(milliseconds: gapDuration));
    }
  }

  Future<String> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return 'Lat: ${position.latitude}, Long: ${position.longitude}\nhttps://www.google.com/maps?q=${position.latitude},${position.longitude}' ;
    } catch (error) {
      print("Error getting location: $error");
      return 'Location unavailable';
    }
  }

  Future<void> requestSmsPermission() async {
    final status = await Permission.sms.request();
    if (!status.isGranted) {
      print("SMS permission not granted");
    }
  }

  Future<void> sendSOSMessage(List<String> recipients, String message) async {
    final Telephony telephony = Telephony.instance;

    bool? permissionsGranted = await telephony.requestPhonePermissions;
    if (permissionsGranted!) {
      try {
        for (String recipient in recipients) {
          await telephony.sendSms(
            to: recipient,
            message: message,
          );
        }
      } catch (error) {
        print("Error sending SMS: $error");
      }
    } else {
      print("SMS permissions not granted.");
    }
  }

  Future<void> makeCall(String phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } catch (error) {
      print("Error making call: $error");
    }
  }

  Future<void> handleSOS() async {
  var locationPermission = await Permission.location.request();
  var callPermission = await Permission.phone.request();

  if (locationPermission.isGranted && callPermission.isGranted) {
    final provider = Provider.of<ContactProvider>(context, listen: false);
    final contacts = provider.contacts;
    final contactNumbers = contacts.map((c) => c.phoneNumber).toList();
    String policeStationNumber = '8610721331';
    String location = await getCurrentLocation();
    String sosMessage = 'SOS! I need help. My location is: $location';

    await _checkAndRequestPermission();

    await sendSOSMessage(contactNumbers, sosMessage);
    await sendSOSMessage([policeStationNumber], sosMessage);
    await makeCall(policeStationNumber);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SOS alert sent and call made.')),
    );

    if (mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop(); // Go back to the previous page with animation
        }
      });
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permissions denied. SOS cannot be sent.')),
    );

    if (mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop(); // Go back to the previous page with animation
        }
      });
    }// Navigate back even if permissions are denied
  }
}



  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _turnOffFlashlight();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF0F0), Color(0xFFFFDAB9)], // Gradient background colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildTitle(),
              const SizedBox(height: 20),
              _buildSOSButton(),
              const Spacer(),
              _buildSafeButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Text(
          'Calling emergency...',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Please stand by, we are currently requesting for help. Your emergency contacts and nearby rescue services would see your call for help.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildSOSButton() {
    return Expanded(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF7E7B), Color(0xFFFFAD59)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    countdown.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ElevatedButton(
        onPressed: () {
          // Stop the SOS process and go back
          _timer.cancel(); // Cancel the timer
          Navigator.of(context).pop(); // Navigate back to the previous page with animation
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7E7B), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'I AM SAFE',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}