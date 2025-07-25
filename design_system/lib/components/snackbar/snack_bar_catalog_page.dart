import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/snackbar/snack_bar.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class SnackBarCatalogPage extends StatelessWidget {
  const SnackBarCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Snack bar catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          PButton(
            text: 'Single line',
            onPressed: () => showPSnackBar(
              'One line text string.',
              context: context,
            ),
          ),
          const SizedBox(height: Grid.s),
          PButton(
            text: 'Single line with a button',
            onPressed: () => showPSnackBar(
              'One line text string with one action.',
              buttonText: 'Action',
              context: context,
            ),
          ),
          const SizedBox(height: Grid.s),
          PButton(
            text: 'Two lines',
            onPressed: () {
              showPSnackBar(
                'Two line text string. One to two lines is preferable on mobile and tablet.',
                context: context,
              );
            },
          ),
          const SizedBox(height: Grid.s),
          PButton(
            text: 'Two lines with a button',
            onPressed: () {
              showPSnackBar(
                'Two lines with one action. One to two lines is preferable on mobile.',
                buttonText: 'Action',
                context: context,
              );
            },
          ),
          const SizedBox(height: Grid.s),
          PButton(
            text: 'Two lines with longer text button',
            onPressed: () {
              showPSnackBar(
                'Two lines with one action. One to two lines is preferable on mobile and tablet.',
                buttonText: 'Long text button',
                longButton: true,
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
