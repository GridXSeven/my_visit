import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visits_prod/brains/cards_brain.dart';
import 'package:visits_prod/brains/navigation/custom_navigator.dart';
import 'package:visits_prod/brains/templates_brain.dart';
import 'package:visits_prod/components/buttons/custom_button.dart';
import 'package:visits_prod/components/cards/cards.dart';
import 'package:visits_prod/components/scaffolds/custom_scaffold.dart';
import 'package:visits_prod/ui_blocs/create_card/select_template_page.dart';
import 'package:visits_prod/ui_utils/context_theme_extensions.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<TemplatesBrain>().init();
      context.read<CardsBrain>().getMyCards();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          if (context.watch<CardsBrain>().myCards.isNotEmpty) MyCards(),
          SizedBox(height: 16),
          CustomButton(
            text: "Create New",
            onTap: () {
              CustomNavigator.push(context, SelectTemplatePage());
            },
          )
        ],
      ),
    );
  }
}

class MyCards extends StatefulWidget {
  MyCards({Key? key}) : super(key: key);

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  PageController controller = PageController(
    viewportFraction: 0.75,
  );

  int currentIndex = 0;

  Widget _dotsBuilder(BuildContext context, int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
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
    final allPages = context.watch<CardsBrain>().myCards;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: (90 / 50),
          child: PageView.builder(
            onPageChanged: (i) {
              setState(() {
                currentIndex = i;
              });
            },
            controller: controller,
            itemCount: allPages.length + 1,
            itemBuilder: (c, i) {
              if (i == 0) {
                return CardEmptyCreate();
              }
              return CardNetwork(
                url: allPages[i - 1].pdfPass,
              );
            },
          ),
        ),
        SizedBox(height: 16),
        _dotsBuilder(context, allPages.length + 1),
      ],
    );
  }
}
