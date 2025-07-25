import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginWarningWidget extends StatelessWidget {
  final String description;
  final bool isFirstLogin;
  final ThemeMode? themeMode;
  const LoginWarningWidget({
    super.key,
    required this.description,
    this.themeMode = ThemeMode.light,
    required this.isFirstLogin,
  });
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    String icon = DesignImagesPath.warningLoginDark;

    if (themeMode == ThemeMode.dark) {
      icon = DesignImagesPath.warningLoginLight;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.s,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: screenSize.width * 0.4,
            ),
            const SizedBox(
              height: Grid.m,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: Grid.l,
            ),
            PButton(
              text: isFirstLogin ? 'hesap_ac' : 'giris_yap',
              onPressed: () {},
            ),
            if (isFirstLogin) ...[
              const SizedBox(
                height: Grid.m,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'account_already_exist_question',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                    TextSpan(
                      text: 'splash_login',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: context.pColorScheme.primary,
                          ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
