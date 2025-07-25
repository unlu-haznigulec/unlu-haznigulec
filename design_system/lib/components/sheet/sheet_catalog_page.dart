import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/sheet/bottom_sheet_picker.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/route/page_navigator.dart';

class SheetCatalogPage extends StatelessWidget {
  const SheetCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Sheet catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          PButton(
            text: 'Show bottom sheet',
            onPressed: () {
              _showPBottomSheet(context);
            },
          ),
          const SizedBox(height: Grid.m),
          PButton(
            text: 'Show bottom sheet picker',
            onPressed: () {
              _showBottomSheetPicker(context);
            },
          ),
        ],
      ),
    );
  }

  void _showBottomSheetPicker(BuildContext context) {
    PPicker.showPBottomPicker(
      context: context,
      message: 'Helper text',
      onCancel: () {
        PageNavigator.pop();
      },
      actions: <PPickerAction>[
        PPickerAction(
          icon: Icons.directions_subway,
          text: 'Option 1',
          action: () {
            PageNavigator.pop();
          },
        ),
        PPickerAction(
          icon: Icons.drafts,
          text: 'Option 2',
          action: () {
            PageNavigator.pop();
          },
        ),
        PPickerAction(
          icon: Icons.https,
          text: 'Destructive option',
          destructive: true,
          action: () {
            PageNavigator.pop();
          },
        ),
      ],
    );
  }

  void _showPBottomSheet(BuildContext context) {
    PBottomSheet.show(
      context,
      child: const Padding(
        padding: EdgeInsets.all(Grid.m),
        child: Text('Dummy content, can be anything'),
      ),
      positiveAction: PBottomSheetAction(
        text: 'Accept',
        action: () {
          Navigator.of(context).pop();
        },
      ),
      negativeAction: PBottomSheetAction(
        text: 'Cancel',
        action: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
