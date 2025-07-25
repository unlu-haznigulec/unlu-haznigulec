import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/place_holder/login_warning_widget.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PlaceHolderCatalogPage extends StatelessWidget {
  const PlaceHolderCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Place Holder Catalog'),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: const Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                NoDataWidget(
                  message: 'no_news_found',
                ),
                SizedBox(
                  width: 15,
                ),
                NoDataWidget(
                  message: 'no_news_found',
                  themeMode: ThemeMode.dark,
                ),
              ],
            ),
            Row(
              children: [
                LoginWarningWidget(
                  isFirstLogin: true,
                  description: 'description',
                ),
                SizedBox(
                  width: Grid.m,
                ),
                LoginWarningWidget(
                  isFirstLogin: false,
                  description: 'description',
                ),
              ],
            ),
            Row(
              children: [
                LoginWarningWidget(
                  themeMode: ThemeMode.dark,
                  isFirstLogin: true,
                  description: 'description',
                ),
                SizedBox(
                  width: 15,
                ),
                LoginWarningWidget(
                  themeMode: ThemeMode.dark,
                  isFirstLogin: false,
                  description: 'description',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
