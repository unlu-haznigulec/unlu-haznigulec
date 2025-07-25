import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class KeyboardDoneAction extends StatefulWidget {
  const KeyboardDoneAction({
    required this.child,
    super.key,
    required this.focusNode,
  });

  final Widget child;
  final FocusNode focusNode;

  @override
  State<KeyboardDoneAction> createState() => _KeyboardDoneActionState();
}

class _KeyboardDoneActionState extends State<KeyboardDoneAction> {
  KeyboardActionsConfig _buildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: context.pColorScheme.secondary,
      keyboardSeparatorColor: context.pColorScheme.secondary,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: widget.focusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.only(right: Grid.m),
                  child: Text(
                    L10n.tr('tamam'),
                    style: TextStyle(
                      color: context.pColorScheme.primary,
                      fontSize: Grid.m,
                    ),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      autoScroll: false,
      config: _buildConfig(),
      child: Center(
        child: widget.child,
      ),
    );
  }
}
