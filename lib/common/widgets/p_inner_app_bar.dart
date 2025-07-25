import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/p_inner_navigation_bar.dart';

class PInnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool usePopScope;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? tabBar;
  final bool hasBottom;
  final bool implyLeading;
  final bool showClose;
  final double dividerHeight;
  final Function()? onPressed;
  final bool isChangePasswordRequired;
  final bool backButtonPressedDisposeClosedPage;
  final Function()? backButtonPressedDisposeClosedFunction;

  const PInnerAppBar({
    super.key,
    this.usePopScope = true,
    required this.title,
    this.subtitle,
    this.actions,
    this.tabBar,
    this.hasBottom = false,
    this.implyLeading = true,
    this.showClose = false,
    this.dividerHeight = 0.5,
    this.onPressed,
    this.isChangePasswordRequired = false,
    //Device'ın back tuşuna engel olması durumu için eklendi
    this.backButtonPressedDisposeClosedPage = false,
    //Device'ın back tuşuna basınca çalışması istenen method olması için eklendi
    this.backButtonPressedDisposeClosedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return !usePopScope
        ? PInnerNavigationBar(
            implyLeading: implyLeading,
            onPressed: onPressed,
            title: title,
            subtitle: subtitle,
            actions: actions,
            showClose: showClose,
          )
        : PopScope(
            canPop: false,
            onPopInvoked: isChangePasswordRequired || backButtonPressedDisposeClosedPage
                ? (backButtonPressedDisposeClosedPage && backButtonPressedDisposeClosedFunction != null)
                    ? (_) => backButtonPressedDisposeClosedFunction?.call()
                    : (_) {}
                : (bool didPop) async {
                    if (didPop) {
                      return;
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
            child: PInnerNavigationBar(
              implyLeading: implyLeading,
              onPressed: onPressed,
              title: title,
              subtitle: subtitle,
              actions: actions,
              showClose: showClose,
            ),
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (hasBottom ? 181 : 0),
      );
}
