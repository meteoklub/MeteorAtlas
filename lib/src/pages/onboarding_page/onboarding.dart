import 'package:flutter/material.dart';
import '../../../domain/services/route_service.dart';
import '../../../domain/theme/consts.dart';
import '../../components/shake_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);
  static const routeName = "/Onboarding";

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final List<OnboardingStep> onboardingSteps = [
    OnboardingStep(
      imageUrl: 'assets/svg/sun.webp',
      title: 'Welcome to MeteorAtlas!',
      description:
          'Cloud atlas, foreweather, risk weather notification and more',
    ),
    OnboardingStep(
      imageUrl: 'assets/svg/novy.webp',
      title: 'Stay informed',
      description:
          'Share your location with us so we can alert you in case of danger',
    ),
    OnboardingStep(
      imageUrl: 'assets/svg/novy.webp',
      title: 'Join Meteoklub',
      description:
          'Share your location with us so we can alert you in case of danger',
    ),
  ];
  var currentPage = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        itemCount: onboardingSteps.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OnboardingStepWidget(
                  onboardingStep: onboardingSteps[index],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (index + 1 == onboardingSteps.length) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.nickname, (route) => false);
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.slowMiddle,
                    );
                  }
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ShakeWidget(
                    child: Text(
                      AppLocalizations.of(context).next_step,
                      style: kContinueText.copyWith(color: Colors.amber),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class OnboardingStep {
  final String imageUrl;
  final String title;
  final String description;

  OnboardingStep({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class OnboardingStepWidget extends StatelessWidget {
  final OnboardingStep onboardingStep;

  const OnboardingStepWidget({
    Key? key,
    required this.onboardingStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              onboardingStep.title,
              textAlign: TextAlign.center,
              style: kHeadline.copyWith(
                color: Colors.amber,
              ),
            ).animate().fade(delay: const Duration(milliseconds: 500)),
          ),
          const SizedBox(height: 40),
          Center(
              child: Image.asset(
            onboardingStep.imageUrl,
            color: Colors.white,
            width: MediaQuery.of(context).size.width - 40,
          ).animate().scale().move(delay: 300.ms, duration: 600.ms)),
          const SizedBox(height: 80),
          Text(
            onboardingStep.description,
            textAlign: TextAlign.center,
            style: kSubtitle.copyWith(color: Colors.amber),
          ).animate().fadeIn() // uses `Animate.defaultDuration`
        ],
      ).animate().moveY(begin: 100, duration: 600.ms),
    );
  }
}
