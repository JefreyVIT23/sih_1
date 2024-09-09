// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sih_1/pages/contact/contact_page.dart';
import 'package:sih_1/pages/dashboard/dashboard_page.dart';
import 'package:sih_1/pages/help/help_page.dart';
import 'package:sih_1/pages/login_register/models/auth_provider.dart';
import 'package:sih_1/pages/maps/map_page.dart';
import 'package:sih_1/pages/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 1); // Controller for page navigation
  final NotchBottomBarController _controller = NotchBottomBarController(index: 1);

  // List of pages to navigate to
  final List<Widget> _pages = [
    MapPage(),
    DashboardPage(),
    ContactPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _controller.index = index;  // Update controller index
          });
        },
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        // The bottom navigation bar widget
        // notchColor: Colors.blue, // Color of the notch
        // showBottomRadius: false,
        showBlurBottomBar: true,
        durationInMilliSeconds: 300,
        showLabel: true,
        itemLabelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 10
                    ), 
        elevation: 2,
        blurOpacity: 0.2,
        blurFilterX: 5.0,
        blurFilterY: 10.0,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.location_pin,
              color: const Color(0xff132137),
            ),
            itemLabel: 'Map',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.home_outlined,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.home,
              color: const Color(0xff132137),
            ),
            itemLabel: 'Dashboard',
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.person_outline,
              color: Colors.grey,
            ),
            activeItem: Icon(
              Icons.person,
              color: const Color(0xff132137),
            ),
            itemLabel: 'Contacts',
          ),
        ],
        onTap: (index) {
          setState(() {
            _controller.index = index; // Update controller index
          });
          _pageController.jumpToPage(index); // Navigate to the selected page
        },
        kIconSize: 20,
        kBottomRadius: 32,
      ),
    );
  }
}