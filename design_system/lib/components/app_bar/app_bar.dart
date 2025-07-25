import 'package:design_system/components/app_bar/app_banner.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_core/keys/keys.dart';
import 'package:p_core/utils/platform_utils.dart';

abstract class PBaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottomWidget;

  const PBaseAppBar({Key? key, this.bottomWidget}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottomWidget?.preferredSize.height ?? 0.0));
}

abstract class PBaseStatefulAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottomWidget;

  const PBaseStatefulAppBar({Key? key, this.bottomWidget}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottomWidget?.preferredSize.height ?? 0.0));
}

class PAppBarCoreWidget extends PBaseAppBar {
  final String title;
  final Widget? titleWidget;
  final double? titleSpacing;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? backgroundColor;
  final bool? centerTitle;
  final bool isImpersonationEnabled;

  const PAppBarCoreWidget({
    Key? key,
    this.title = '',
    this.titleWidget,
    this.titleSpacing,
    this.actions,
    this.bottom,
    this.leading,
    this.elevation,
    this.backgroundColor,
    this.centerTitle,
    this.isImpersonationEnabled = false,
  }) : super(key: key, bottomWidget: bottom);

  @override
  Widget build(BuildContext context) {
    return AppBanner(
      text: 'Impersonate',
      isVisible: isImpersonationEnabled,
      child: AppBar(
        key: const Key(AppBarKeys.appBar),
        titleSpacing: titleSpacing,
        centerTitle: centerTitle,
        title: titleWidget ??
            Text(
              title,
              style: context.pAppStyle.labelMed18primary,
            ),
        leading: leading,
        leadingWidth: 19 + Grid.m,
        actions: actions,
        bottom: bottomWidget,
        elevation: elevation,
        backgroundColor: isImpersonationEnabled ? context.pColorScheme.critical : backgroundColor,
        automaticallyImplyLeading: false,
      ),
    );
  }
}

class PCancelAppBar extends PBaseAppBar {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const PCancelAppBar({
    Key? key,
    this.onPressed,
    this.iconColor,
    this.systemOverlayStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close, color: iconColor ?? context.pColorScheme.primary, size: Grid.xl),
        onPressed: onPressed,
      ),
      elevation: 0,
      backgroundColor: context.pColorScheme.transparent,
      systemOverlayStyle: systemOverlayStyle,
    );
  }
}

class PSearchAppBar extends PBaseAppBar {
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? backgroundColor;
  final SystemUiOverlayStyle systemOverlayStyle;
  final TextStyle? searchBarInputStyle;
  final String? searchBarHint;
  final TextStyle? searchBarHintStyle;
  final Color? searchBarBackgroundColor;
  final double? searchBarBorderRadius;
  final Color? searchBarIconColor;
  final Color? searchBarCursorColor;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool autocorrect;
  final bool showLeading;
  final bool isSearchEnabled;
  final BorderSide? borderSide;
  final double? titleSpacing;

  const PSearchAppBar({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.controller,
    this.textInputAction,
    this.searchBarInputStyle,
    this.searchBarHint,
    this.searchBarHintStyle,
    this.searchBarBackgroundColor,
    this.searchBarBorderRadius,
    this.searchBarIconColor,
    this.searchBarCursorColor,
    this.focusNode,
    this.autoFocus = false,
    this.autocorrect = false,
    this.actions,
    this.bottom,
    this.leading,
    this.elevation,
    this.backgroundColor,
    this.systemOverlayStyle = SystemUiOverlayStyle.light,
    this.showLeading = true,
    this.isSearchEnabled = true,
    this.borderSide,
    this.titleSpacing,
  }) : super(key: key, bottomWidget: bottom);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: PSearchBox(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        controller: controller,
        textInputAction: textInputAction,
        focusNode: focusNode,
        autoFocus: autoFocus,
        searchBarCursorColor: searchBarCursorColor,
        autocorrect: autocorrect,
        searchBarInputStyle: searchBarInputStyle,
        isSearchEnabled: isSearchEnabled,
        searchBarBackgroundColor: searchBarBackgroundColor,
        borderSide: borderSide,
        searchBarBorderRadius: searchBarBorderRadius,
        searchBarHint: searchBarHint,
        searchBarHintStyle: searchBarHintStyle,
        searchBarIconColor: searchBarIconColor,
        onClear: onClear,
      ),
      titleSpacing: titleSpacing,
      leading: leading,
      actions: actions,
      bottom: bottomWidget,
      elevation: elevation,
      backgroundColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle,
      automaticallyImplyLeading: showLeading,
    );
  }
}

class PSearchBox extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autoFocus;
  final Color? searchBarCursorColor;
  final bool autocorrect;
  final TextStyle? searchBarInputStyle;
  final bool isSearchEnabled;
  final Color? searchBarBackgroundColor;
  final BorderSide? borderSide;
  final double? searchBarBorderRadius;
  final String? searchBarHint;
  final TextStyle? searchBarHintStyle;
  final Color? searchBarIconColor;
  final VoidCallback? onClear;
  final VoidCallback? onTap;

  const PSearchBox({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.autoFocus = false,
    this.searchBarCursorColor,
    this.autocorrect = false,
    this.searchBarInputStyle,
    this.isSearchEnabled = false, // TODO(Sita): Check if shouldn't be true by default
    this.searchBarBackgroundColor,
    this.borderSide,
    this.searchBarBorderRadius,
    this.searchBarHint,
    this.searchBarHintStyle,
    this.searchBarIconColor,
    this.onClear,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: TextField(
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          autofocus: autoFocus,
          cursorColor: searchBarCursorColor ?? context.pColorScheme.iconPrimary.shade900,
          autocorrect: autocorrect,
          style: searchBarInputStyle,
          decoration: InputDecoration(
            enabled: isSearchEnabled,
            filled: true,
            fillColor: searchBarBackgroundColor ?? context.pColorScheme.lightHigh,
            border: OutlineInputBorder(
              borderSide: borderSide ?? const BorderSide(),
              borderRadius: BorderRadius.circular(searchBarBorderRadius ?? Grid.m),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: borderSide ?? const BorderSide(),
              borderRadius: BorderRadius.circular(searchBarBorderRadius ?? Grid.m),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(searchBarBorderRadius ?? Grid.m),
            ),
            isDense: true,
            contentPadding: PlatformUtils.isAndroid ? const EdgeInsets.only(top: 20) : EdgeInsets.zero,
            hintText: searchBarHint,
            hintStyle: searchBarHintStyle,
            prefixIcon: Icon(Icons.search, color: searchBarIconColor ?? context.pColorScheme.iconPrimary.shade700),
            suffixIcon: controller?.text.trim().isNotEmpty ?? false
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: searchBarIconColor ?? context.pColorScheme.iconPrimary.shade700,
                      size: 16,
                    ),
                    onPressed: onClear ?? controller?.clear,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
