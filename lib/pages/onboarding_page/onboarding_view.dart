import 'package:flutter/material.dart';
import 'package:fund_app/pages/auth/auth_gate.dart';
import 'package:fund_app/pages/onboarding_page/onboarding_items.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pagecontroller = PageController();

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: isLastPage
              ? getStarted()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => pagecontroller
                            .jumpToPage(controller.items.length - 1),
                        child: const Text("Skip")),
                    SmoothPageIndicator(
                      controller: pagecontroller,
                      count: controller.items.length,
                      onDotClicked: (index) => pagecontroller.animateToPage(
                          index,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeIn),
                      effect: const WormEffect(
                        activeDotColor: Colors.redAccent,
                        dotWidth: 12,
                        dotHeight: 12,
                      ),
                    ),
                    TextButton(
                        onPressed: () => pagecontroller.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeIn),
                        // onPressed: () {
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (context) => AuthGate()));
                        // },
                        child: const Text("Next")),
                  ],
                ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          onPageChanged: (index) =>
              setState(() => isLastPage = controller.items.length - 1 == index),
          itemCount: controller.items.length,
          controller: pagecontroller,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(controller.items[index].image),
                const SizedBox(height: 15),
                Text(
                  controller.items[index].title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(controller.items[index].description,
                    style: const TextStyle(color: Colors.grey, fontSize: 17),
                    textAlign: TextAlign.center),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
      ), // BoxDecoration
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AuthGate()));
          },
          child: const Text(
            "Get started",
            style: TextStyle(color: Colors.white),
          )), // TextButton
    );
  } // Container
}
