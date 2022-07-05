import 'package:flutter/material.dart';
import 'package:visits_prod/components/texts/custom_text.dart';
import 'package:visits_prod/ui_utils/context_theme_extensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.onTap, this.text, Key? key})
      : super(key: key);

  final VoidCallback onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: context.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          highlightColor:
              context.theme.colorScheme.inverseSurface.withOpacity(0.3),
          child: Container(
            height: 48,
            child: Center(
              child: CustomText(
                text ?? "here is a btn",
                style: context.theme.textTheme.labelLarge
                    ?.copyWith(color: context.theme.colorScheme.surface),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAddButton extends StatelessWidget {
  const CustomAddButton({required this.onTap, this.text, Key? key})
      : super(key: key);

  final VoidCallback onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: context.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onTap,
          highlightColor:
              context.theme.colorScheme.inverseSurface.withOpacity(0.3),
          child: Container(
            height: 48,
            child: Center(
              child: Icon(
                Icons.add,
                color: context.theme.colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
