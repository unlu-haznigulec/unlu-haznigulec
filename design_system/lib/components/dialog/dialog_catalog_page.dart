import 'dart:async';

import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/dialog/dialog.dart';
import 'package:design_system/components/list/list_item.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/platform_utils.dart';

class DialogCatalogPage extends StatelessWidget {
  const DialogCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Dialogs'),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(Grid.m),
            child: Text('Dialog styles changes depending platform'),
          ),
          const Divider(height: 0),
          PListItem(
            title: 'Alert Dialog',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => PDialog.showAlertDialog(
              message: 'Warning message',
              context: context,
              positiveAction: PDialogAction(
                text: 'Positive Action',
                action: () {
                  if (PlatformUtils.isIos) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              negativeAction: PDialogAction.cancel(
                action: () {
                  if (PlatformUtils.isIos) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
          const Divider(height: 0),
          PListItem(
            title: 'Text Field Dialog',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => PDialog.showTextFieldDialog(
              title: 'Title',
              hint: 'hint',
              context: context,
              positiveAction: PDialogAction(
                text: 'Positive Action',
                action: () {
                  if (PlatformUtils.isIos) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              negativeAction: PDialogAction.cancel(
                action: () {
                  if (PlatformUtils.isIos) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
          const Divider(height: 0),
          PListItem(
            title: 'Double Number Field Dialog',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => PDialog.showDoubleNumberTextFieldDialog(
              title: 'Double field only accepts numeric input',
              context: context,
              positiveAction: PDialogAction(
                text: 'Positive Action',
                action: () {
                  if (PlatformUtils.isIos) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              negativeAction: PDialogAction.cancel(
                action: () {
                  if (PlatformUtils.isIos) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
          const Divider(height: 0),
          PListItem(
            title: 'Loading Dialog',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Timer(
                const Duration(seconds: 2),
                () {
                  Navigator.of(context).pop();
                },
              );
              PDialog.showLoadingDialog(text: 'Loading...', context: context);
            },
          ),
        ],
      ),
    );
  }
}
