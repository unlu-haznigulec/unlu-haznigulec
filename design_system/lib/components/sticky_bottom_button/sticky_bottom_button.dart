import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/keys.dart';
import 'package:p_core/route/page_navigator.dart';

/// Moved from core/ui/button, code needs to be modernized
class StickyBottomButton extends StatelessWidget {
  final BuildContext context;
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool useOutlinedButton;
  final bool useIconButton;
  final Widget? buttonIcon;
  final bool addBottomPadding;
  final String? infoMessage;

  const StickyBottomButton({
    super.key,
    required this.context,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.backgroundColor,
    this.borderColor,
    this.useOutlinedButton = false,
    this.useIconButton = false,
    this.buttonIcon,
    this.addBottomPadding = true,
    this.infoMessage,
  }) : assert((useIconButton == true && buttonIcon != null) || useIconButton == false);

  @override
  Widget build(BuildContext context) {
    final bool _isNestedPage = PageNavigator.isRoot != true;
    final double _calculatedBottomPadding = addBottomPadding ? MediaQuery.of(context).padding.bottom : 0;
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: (_calculatedBottomPadding < Grid.s || _isNestedPage) ? Grid.s : _calculatedBottomPadding,
          horizontal: Grid.m,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.pColorScheme.lightHigh,
          border: Border(
            top: BorderSide(
              color: borderColor ?? backgroundColor ?? context.pColorScheme.lightHigh,
              width: 1.5,
            ),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: _isNestedPage ? context.pColorScheme.darkLow : context.pColorScheme.transparent,
              blurRadius: _isNestedPage ? 0.5 : 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (infoMessage?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Grid.xs),
                  child: Text(
                    infoMessage!,
                    style: context.pAppStyle.interRegularBase.copyWith(
                      fontSize: Grid.s + Grid.xs + Grid.xxs,
                      height: lineHeight150,
                      color: context.pColorScheme.darkMedium,
                    ),
                  ),
                ),
              getBottomButton(),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getBottomButton() {
    if (useOutlinedButton)
      return POutlinedButton(
        key: const Key(ButtonKeys.stickyBottomButton),
        onPressed: loading == true ? null : onPressed,
        text: text,
        loading: loading,
        fillParentWidth: true,
      );
    else if (useIconButton)
      return PButtonWithIcon(
        key: const Key(ButtonKeys.stickyBottomButton),
        onPressed: loading == true ? null : onPressed,
        text: text,
        loading: loading,
        icon: buttonIcon!,
        fillParentWidth: true,
      );
    else
      return PButton(
        key: const Key(ButtonKeys.stickyBottomButton),
        onPressed: loading == true ? null : onPressed,
        text: text,
        loading: loading,
        fillParentWidth: true,
      );
  }
}
