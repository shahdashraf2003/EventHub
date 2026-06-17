import 'package:event_hub/features/authentication/presentation/screens/signin_screen.dart';
import 'package:event_hub/features/onboading/presentation/cubit/onboarding_cubit.dart';
import 'package:event_hub/features/onboading/presentation/screens/widgets/bottom_sheet.dart';
import 'package:event_hub/features/onboading/presentation/screens/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  static const List<Map<String, String>> pages = [
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

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final isLastPage = state.currentIndex == pages.length - 1;

            void nextPage() {
              if (isLastPage) {
                context.read<OnboardingCubit>().completeOnboarding();
              } else {
                controller.nextPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              }
            }

            void skip() {
              context.read<OnboardingCubit>().completeOnboarding();
            }

            return Column(
              children: [
                const SizedBox(height: 100),
                Expanded(
                  child: ImageSlider(
                    controller: controller,
                    pages: pages,
                    onPageChanged: (i) => context.read<OnboardingCubit>().setPageIndex(i),
                  ),
                ),
                BottomSheetContent(
                  title: pages[state.currentIndex]["title"]!,
                  desc: pages[state.currentIndex]["desc"]!,
                  controller: controller,
                  isLastPage: isLastPage,
                  pagesCount: pages.length,
                  onNext: nextPage,
                  onSkip: skip,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
