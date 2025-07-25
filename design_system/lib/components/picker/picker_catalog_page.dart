import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/picker/picker.dart';
import 'package:design_system/components/picker/picker_field.dart';
import 'package:design_system/components/snackbar/snack_bar.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PickerCatalogPage extends StatelessWidget {
  const PickerCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Picker catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          PPickerField<String>(
            label: 'Short picker',
            values: <String>['Option 1', 'Option 2', 'Option 3']
                .map((String s) => PickerItem<String>(value: s, text: s))
                .toList(),
            onChanged: (String? selected) {
              showPSnackBar('Selected: $selected');
            },
            initialValue: 'Option 2',
            helperText: 'This shows 3 options',
          ),
          const SizedBox(height: Grid.m),
          PPickerField<String>(
            label: 'Long picker',
            values: <String>[
              'Option 1',
              'Option 2',
              'Option 3',
              'Option 4',
              'Option 5',
              'Option 6',
              'Option 7',
              'Option 8',
              'Option 9',
              'Option 10',
              'Option 11',
              'Option 12',
            ].map((String s) => PickerItem<String>(value: s, text: s)).toList(),
            onChanged: (String? selected) {
              showPSnackBar('Selected: $selected');
            },
            helperText: 'This shows 12 options',
          ),
        ],
      ),
    );
  }
}
