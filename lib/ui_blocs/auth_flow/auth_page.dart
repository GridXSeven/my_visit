import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visits_prod/brains/user_data.dart';
import 'package:visits_prod/components/animations/switch_animation.dart';
import 'package:visits_prod/components/buttons/custom_button.dart';
import 'package:visits_prod/components/fields/custom_text_field.dart';
import 'package:visits_prod/components/scaffolds/custom_scaffold.dart';
import 'package:visits_prod/components/texts/custom_text.dart';
import 'package:visits_prod/ui_blocs/main_page/main_page.dart';

class AuthPage extends StatelessWidget {
  AuthPage({Key? key}) : super(key: key);

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  ValueNotifier<bool> register = ValueNotifier<bool>(true);
//fddfvd
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: register,
            builder: (context, v, child) {
              return SwitchAnimatedContainer(
                index: v ? 0 : 1,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomText("REG"),
                        SizedBox(height: 8),
                        CustomTextField(
                          label: "email",
                          controller: email,
                        ),
                        SizedBox(height: 8),
                        CustomTextField(
                          label: "pass",
                          controller: pass,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomText("login"),
                        SizedBox(height: 8),
                        CustomTextField(
                          label: "email",
                          controller: email,
                        ),
                        SizedBox(height: 8),
                        CustomTextField(
                          label: "pass",
                          controller: pass,
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          Spacer(),
          ValueListenableBuilder<bool>(
              valueListenable: register,
              builder: (context, v, child) {
                return CustomButton(
                  onTap: () {
                    register.value = !register.value;
                  },
                  text: !v ? "Registration" : "Login",
                );
              }),
          SizedBox(height: 8),
          CustomButton(
            onTap: () async {
              if (register.value) {
                await context.read<UserData>().register(email.text, pass.text);
              } else {
                await context.read<UserData>().login(email.text, pass.text);
              }
              if (context.read<UserData>().user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => MainPage(),
                  ),
                );
              }
            },
            text: "Confirm",
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
