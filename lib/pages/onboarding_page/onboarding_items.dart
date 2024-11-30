import 'package:fund_app/pages/onboarding_page/onboarding_info.dart';

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        image: "assets/onboarding_welcome.png",
        title: "Welcome to FundConnect!",
        description:
            "Join hands to make a difference. Create, share, and support projects effortlessly."),
    OnboardingInfo(
        image: "assets/onboarding_happy.png",
        title: "Empowering Students",
        description:
            "Your small contributions fuel big dreams. Together, let’s support innovative ideas and projects."),
    OnboardingInfo(
        image: "assets/onboarding_project.png",
        title: "Transform Idea into Reality",
        description:
            "Explore a variety of student-driven campaigns and be part of their journey to success."),
    OnboardingInfo(
        image: "assets/onboarding_money.png",
        title: "Simple & Transparent Funding",
        description:
            "Easily track campaign progress and see the impact of your support in real-time."),
  ];
}
