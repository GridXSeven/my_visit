import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visits_prod/brains/navigation/custom_navigator.dart';
import 'package:visits_prod/brains/user_data.dart';
import 'package:visits_prod/components/buttons/custom_button.dart';
import 'package:visits_prod/components/scaffolds/custom_scaffold.dart';
import 'package:visits_prod/components/texts/custom_text.dart';
import 'package:visits_prod/ui_blocs/auth_flow/auth_page.dart';
import 'package:visits_prod/ui_blocs/main_page/main_page.dart';
import 'package:visits_prod/ui_utils/context_theme_extensions.dart';
import 'package:visits_prod/ui_utils/theme_data.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController(
    initialPage: 0,
  );

  int currentIndex = 0;

  final List<String> texts = [
    "Super trext1",
    "Super trext2",
    "Super trext3",
  ];

  final List<String> btnTexts = [
    "Okay!",
    "Next!",
    "Let`s GO!",
  ];

  Widget _dotsBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => dot(context, i),
      ),
    );
  }

  Widget dot(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == currentIndex
              ? context.theme.colorScheme.primary
              : context.theme.disabledColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (i) {
                currentIndex = i;
                setState(() {});
              },
              children: List.generate(
                3,
                (i) => OnBoardingPage(
                  image: "assets/onboarding/onboarding_$i.png",
                  text: texts[i],
                  changeTheme: i == 0,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          _dotsBuilder(context),
          SizedBox(height: 16),
          CustomButton(
            text: btnTexts[currentIndex],
            onTap: () {
              if (currentIndex < 2) {
                controller.animateToPage(currentIndex + 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              } else {
                if (context.read<UserData>().auth) {
                  CustomNavigator.push(context, const MainPage());
                } else {
                  CustomNavigator.push(context, AuthPage());
                }
              }
            },
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage(
      {required this.text,
      required this.image,
      this.changeTheme = false,
      Key? key})
      : super(key: key);

  final String image;
  final String text;
  final bool changeTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            image,
          ),
        ),
        CustomText(
          text,
        ),
        if (changeTheme)
          CupertinoSwitch(
            value: context.watch<ThemeDataBrain>().isDark,
            onChanged: (bool value) {
              context.read<ThemeDataBrain>().changeTheme();
            },
          ),
      ],
    );
  }
}
