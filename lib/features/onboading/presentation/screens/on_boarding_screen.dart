import 'package:event_hub/features/authentication/presentation/screens/signin_screen.dart';
import 'package:event_hub/features/onboading/presentation/screens/widgets/bottom_sheet.dart';
import 'package:event_hub/features/onboading/presentation/screens/widgets/image_slider.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Explore Upcoming and Nearby Events",
      "desc":
          "Discover upcoming events and activities around you in an easy and simple way. Stay updated with what's happening nearby.",
      "image": "assets/images/onboarding1.png",
    },
    {
      "title": "We Have a Modern Events Calendar Feature",
      "desc":
          "View all events in a modern and organized calendar. Plan your schedule and never miss an important event.",
      "image": "assets/images/onboarding2.png",
    },
    {
      "title": "Find More Events or Activities Nearby on the Map",
      "desc":
          "Easily explore nearby events using the map. Find activities close to your location in seconds.",
      "image": "assets/images/onboarding3.png",
    },
  ];

  bool get isLastPage => _currentIndex == pages.length - 1;

  void nextPage() {
    if (isLastPage) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
     Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const SizedBox(height: 100),

          Expanded(
            child: ImageSlider(
              controller: _controller,
              pages: pages,
              onPageChanged: (i) => setState(() => _currentIndex = i),
            ),
          ),

          BottomSheetContent(
            title: pages[_currentIndex]["title"]!,
            desc: pages[_currentIndex]["desc"]!,
            controller: _controller,
            isLastPage: isLastPage,
            pagesCount: pages.length,
            onNext: nextPage,
            onSkip: skip,
          ),
        ],
      ),
    );
  }
}

