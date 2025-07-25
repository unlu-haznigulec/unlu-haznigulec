import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p_core/route/page_navigator.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:p_core/utils/platform_utils.dart';

class PPicker {
  static void showPBottomPicker({
    String? message,
    VoidCallback? onCancel,
    List<PPickerAction>? actions,
    required BuildContext context,
    bool useRootNavigator = true,
  }) {
    if (PlatformUtils.isMobile) {
      KeyboardUtils.dismissKeyboard();
    }
    if (PlatformUtils.isIos) {
      final List<Widget> actionWidgets = <Widget>[
        if (message != null)
          Material(
            child: Container(
              padding: const EdgeInsets.all(Grid.m),
              color: context.pColorScheme.lightHigh,
              child: Center(
                child: Text(
                  message,
                  style: context.pAppStyle.interRegularBase.copyWith(
                    fontSize: Grid.s + Grid.xs + Grid.xxs,
                    color: context.pColorScheme.darkMedium,
                  ),
                ),
              ),
            ),
          ),
        if (actions != null)
          ...actions.map(
            (PPickerAction action) {
              return _IosActionItem(action: action);
            },
          ),
      ];

      showCupertinoModalPopup(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData.light(),
            child: CupertinoActionSheet(
              cancelButton: Material(
                borderRadius: BorderRadius.circular(Grid.m),
                color: context.pColorScheme.backgroundColor,
                child: InkWell(
                  onTap: onCancel ?? () => PageNavigator.pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(Grid.m),
                    child: Center(
                      child: Text(
                        'cancel',
                        style: context.pAppStyle.interMediumBase.copyWith(color: context.pColorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ),
              actions: actionWidgets,
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (BuildContext context) {
          return Container(
            color: context.pColorScheme.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.m,
                      left: Grid.m,
                      right: Grid.m,
                    ),
                    child: Text(
                      message,
                      style: context.pAppStyle.interRegularBase.copyWith(
                        fontSize: Grid.s + Grid.xs + Grid.xxs,
                        color: context.pColorScheme.darkMedium,
                      ),
                    ),
                  ),
                const SizedBox(height: Grid.m),
                if (actions != null && actions.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _AndroidActionItem(action: actions[index]);
                    },
                    itemCount: actions.length,
                  ),
              ],
            ),
          );
        },
      );
    }
  }
}

class PPickerAction {
  final String? text;
  final IconData? icon;
  final VoidCallback? action;
  final bool destructive;
  final Color? iconColor;
  final Color? textColor;

  PPickerAction({this.text, this.icon, this.action, this.destructive = false, this.iconColor, this.textColor});
}

class _IosActionItem extends StatelessWidget {
  final PPickerAction action;

  const _IosActionItem({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pColorScheme.lightHigh,
      child: InkWell(
        onTap: action.action,
        child: Padding(
          padding: const EdgeInsets.all(Grid.m),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (action.icon != null)
                Icon(
                  action.icon,
                  size: Grid.l,
                  color: action.destructive
                      ? context.pColorScheme.critical
                      : action.iconColor ?? context.pColorScheme.darkHigh,
                ),
              if (action.text != null)
                Expanded(
                  child: Text(
                    action.text!,
                    textAlign: TextAlign.center,
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m,
                      color: action.destructive
                          ? context.pColorScheme.critical
                          : action.textColor ?? context.pColorScheme.darkHigh,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AndroidActionItem extends StatelessWidget {
  final PPickerAction action;

  const _AndroidActionItem({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pColorScheme.lightHigh,
      child: InkWell(
        onTap: action.action,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Grid.m),
          child: Row(
            children: <Widget>[
              const SizedBox(width: Grid.m),
              if (action.icon != null)
                Icon(
                  action.icon,
                  size: Grid.l,
                  color: action.destructive
                      ? context.pColorScheme.critical
                      : action.iconColor ?? context.pColorScheme.darkHigh,
                ),
              if (action.icon != null && action.text != null) const SizedBox(width: Grid.l),
              if (action.text != null)
                Text(
                  action.text!,
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m,
                    color: action.destructive
                        ? context.pColorScheme.critical
                        : action.textColor ?? context.pColorScheme.darkHigh,
                  ),
                ),
              const SizedBox(width: Grid.m),
            ],
          ),
        ),
      ),
    );
  }
}
