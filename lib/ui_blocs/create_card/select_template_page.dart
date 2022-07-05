import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visits_prod/brains/templates_brain.dart';
import 'package:visits_prod/components/cards/cards.dart';
import 'package:visits_prod/components/scaffolds/custom_scaffold.dart';
import 'package:visits_prod/ui_blocs/create_card/create_card_page.dart';

class SelectTemplatePage extends StatelessWidget {
  const SelectTemplatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Template> templates = context.watch<TemplatesBrain>().templates;
    return CustomScaffold(
      body: Column(
        children: [
          Text("hbfhdakjbfdsjk"),
          ...List.generate(
            templates.length,
            (i) => CardFile(
              file: templates[i].preview!,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => CreateCardPage(
                      template: templates[i],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
