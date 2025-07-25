import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/design_images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PBottomSheet extends StatelessWidget {
  final Widget? titleWidget;
  final String title;
  final EdgeInsets? titlePadding;
  final TextStyle? titleStyle;
  final String? subTitle;
  final TextStyle? subtitleStyle;
  final AlignmentGeometry? titleAlignment;
  final EdgeInsetsGeometry? titleAndSubtitlePadding;
  final PBottomSheetAction? positiveAction, negativeAction;
  final bool isDismissible;
  final bool showCloseButton;
  final bool enableDrag;
  final bool bottomSafeArea;
  final Widget? child;
  final bool showBackButton;

  const PBottomSheet({
    Key? key,
    this.titleWidget,
    required this.title,
    this.titlePadding,
    this.titleAndSubtitlePadding,
    this.subTitle,
    this.subtitleStyle,
    this.titleStyle,
    this.positiveAction,
    this.negativeAction,
    this.isDismissible = true,
    this.enableDrag = true,
    this.bottomSafeArea = true,
    this.child,
    this.showCloseButton = false,
    this.showBackButton = false,
    this.titleAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: Grid.s,
                ),
                Container(
                  width: Grid.xl - Grid.xs,
                  height: Grid.xs + 1,
                  decoration: BoxDecoration(
                    color: context.pColorScheme.stroke,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Grid.xxs,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      Grid.m,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (titleWidget != null) ...[
                            titleWidget!,
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Grid.m,
                              ),
                              child: PDivider(),
                            ),
                          ],
                          if (title.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (showBackButton) ...[
                                  InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: SvgPicture.asset(
                                      package: 'design_system',
                                      DesignImagesPath.chevron_left,
                                      width: Grid.m,
                                      colorFilter: ColorFilter.mode(
                                        context.pColorScheme.textPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                                Expanded(
                                  child: Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: titleStyle ?? context.pAppStyle.labelMed14textPrimary,
                                  ),
                                ),
                                if (showBackButton) ...[
                                  const Spacer(),
                                  const SizedBox(
                                    width: Grid.m,
                                  ),
                                ],
                              ],
                            ),
                            if (subTitle != null && subTitle!.isNotEmpty)
                              Padding(
                                padding: titleAndSubtitlePadding ??
                                    const EdgeInsets.only(
                                      top: Grid.m,
                                    ),
                                child: Text(
                                  subTitle!,
                                  textAlign: TextAlign.center,
                                  style: subtitleStyle ?? context.pAppStyle.labelReg12textSecondary,
                                ),
                              ),
                            PDivider(
                              padding: titlePadding ??
                                  const EdgeInsets.symmetric(
                                    vertical: Grid.m,
                                  ),
                            ),
                          ],
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: positiveAction != null || negativeAction != null ? Grid.xl + Grid.s : 0,
                            ),
                            child: child ?? const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Grid.m,
            right: Grid.m,
            bottom: Grid.s + Grid.xs,
            child: Row(
              children: [
                if (negativeAction != null)
                  Expanded(
                    child: POutlinedButton(
                      text: negativeAction!.text,
                      onPressed: negativeAction!.action,
                    ),
                  ),
                if (positiveAction != null && negativeAction != null)
                  const SizedBox(
                    width: Grid.s,
                  ),
                if (positiveAction != null)
                  Expanded(
                    child: PButton(
                      text: positiveAction!.text,
                      onPressed: positiveAction!.action,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    Widget? titleWidget,
    String title = '',
    EdgeInsets? titlePadding,
    String? subtitle,
    Widget? content,
    bool useRootNavigator = false,
    EdgeInsetsGeometry? titleAndSubtitlePadding,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? maxHeight,
    PBottomSheetAction? positiveAction,
    PBottomSheetAction? negativeAction,
    bool isDismissible = true,
    bool showCloseButton = false,
    bool enableDrag = true,
    bool bottomSafeArea = true,
    Widget? child,
    bool showBackButton = false,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: context.pColorScheme.backgroundColor,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.sizeOf(context).height * 0.9,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            Grid.m,
          ),
          topLeft: Radius.circular(
            Grid.m,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return PBottomSheet(
          titleWidget: titleWidget,
          title: title,
          titlePadding: titlePadding,
          titleAndSubtitlePadding: titleAndSubtitlePadding,
          subTitle: subtitle,
          subtitleStyle: subtitleStyle,
          titleStyle: titleStyle,
          positiveAction: positiveAction,
          negativeAction: negativeAction,
          isDismissible: isDismissible,
          enableDrag: enableDrag,
          showBackButton: showBackButton,
          bottomSafeArea: bottomSafeArea,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  static Future<T?> showPortfolio<T>(
    BuildContext context, {
    String title = '',
    String? subtitle,
    Widget? content,
    bool useRootNavigator = false,
    EdgeInsetsGeometry? titleAndSubtitlePadding,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? maxHeight,
    PBottomSheetAction? positiveAction,
    PBottomSheetAction? negativeAction,
    bool isDismissible = true,
    bool showCloseButton = false,
    bool enableDrag = true,
    bool bottomSafeArea = true,
    Widget? child,
    Widget? titleWidget,
    bool showBackButton = false,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: context.pColorScheme.backgroundColor,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            Grid.m,
          ),
          topLeft: Radius.circular(
            Grid.m,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return PBottomSheet(
          title: title,
          titleAndSubtitlePadding: titleAndSubtitlePadding,
          subtitleStyle: subtitleStyle,
          titleStyle: titleStyle,
          positiveAction: positiveAction,
          negativeAction: negativeAction,
          isDismissible: isDismissible,
          enableDrag: enableDrag,
          bottomSafeArea: bottomSafeArea,
          titleWidget: titleWidget,
          showBackButton: showBackButton,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  static Future<T?> showError<T>(
    BuildContext context, {
    required String content,
    String? errorCode,
    bool useRootNavigator = false,
    TextStyle? contentStyle,
    double? maxHeight,
    bool isDismissible = true,
    bool showCloseButton = false,
    bool enableDrag = true,
    bool bottomSafeArea = true,
    bool showOutlinedButton = false,
    String? outlinedButtonText,
    Function()? onOutlinedButtonPressed,
    bool showFilledButton = false,
    String? filledButtonText,
    Function()? onFilledButtonPressed,
    String? customImagePath = '',
    bool isSuccess = false,
    bool isCritical = false,
    String? title,
    Widget? child,
    bool showBackButton = false,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: context.pColorScheme.backgroundColor,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        minWidth: MediaQuery.sizeOf(context).width,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            Grid.m,
          ),
          topLeft: Radius.circular(
            Grid.m,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return PBottomSheet(
          title: title ?? '',
          isDismissible: isDismissible,
          enableDrag: enableDrag,
          showBackButton: showBackButton,
          bottomSafeArea: bottomSafeArea,
          child: Padding(
            padding: EdgeInsets.only(
              top: Grid.m,
              bottom: !bottomSafeArea ? Grid.m : EdgeInsets.zero.bottom,
            ),
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    customImagePath!.isNotEmpty
                        ? customImagePath
                        : isSuccess
                            ? DesignImagesPath.check_circle
                            : DesignImagesPath.alert_circle,
                    height: 52,
                    width: 52,
                    package: 'design_system',
                    colorFilter: ColorFilter.mode(
                      isCritical ? context.pColorScheme.critical : context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: contentStyle ?? context.pAppStyle.labelReg16textPrimary,
                  ),
                  const SizedBox(
                    height: Grid.s,
                  ),
                  if (errorCode != null && errorCode.isNotEmpty)
                    Text(
                      errorCode,
                      textAlign: TextAlign.center,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  const SizedBox(
                    height: Grid.l,
                  ),
                  if (showOutlinedButton || showFilledButton)
                    SizedBox(
                      height: 52,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          if (showOutlinedButton)
                            Expanded(
                              child: POutlinedButton(
                                text: outlinedButtonText ?? '',
                                variant: isCritical ? PButtonVariant.error : PButtonVariant.brand,
                                onPressed: () => onOutlinedButtonPressed?.call(),
                              ),
                            ),
                          if (showOutlinedButton && showFilledButton)
                            const SizedBox(
                              width: Grid.s,
                            ),
                          if (showFilledButton)
                            Expanded(
                              child: PButton(
                                text: filledButtonText ?? '',
                                variant: isCritical ? PButtonVariant.error : PButtonVariant.brand,
                                onPressed: () => onFilledButtonPressed?.call(),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<T?> showRaw<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool useRootNavigator = false,
    double? maxHeight,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pColorScheme.backgroundColor,
      constraints: BoxConstraints(maxHeight: maxHeight ?? (MediaQuery.of(context).size.height * 0.70)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(Grid.m),
          topEnd: Radius.circular(Grid.m),
        ),
      ),
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: builder,
    );
  }

  //Kullanıcı tema ayarlarının loginde değiştiği anda kullanılmak için yapılmıştır.
  //Yalnızca biometric login istermisin uyarı moadalı için kullanılıyor.
  //Loginden sonra açılacak bir modal sheet olursa kullanılabilir.
  static Future<T?> showThemeDynamic<T>(
    BuildContext context, {
    Widget? titleWidget,
    String title = '',
    EdgeInsets? titlePadding,
    String? subtitle,
    Widget? content,
    bool useRootNavigator = false,
    EdgeInsetsGeometry? titleAndSubtitlePadding,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    double? maxHeight,
    PBottomSheetAction? positiveAction,
    PBottomSheetAction? negativeAction,
    bool isDismissible = true,
    bool showCloseButton = false,
    bool enableDrag = true,
    bool bottomSafeArea = true,
    Widget Function()? childBuilder,
    bool showBackButton = false,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: context.pColorScheme.transparent,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.sizeOf(context).height * 0.9,
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(Grid.m),
              topLeft: Radius.circular(Grid.m),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ColoredBox(
            color: context.pColorScheme.backgroundColor,
            child: PBottomSheet(
              titleWidget: titleWidget,
              title: title,
              titlePadding: titlePadding,
              titleAndSubtitlePadding: titleAndSubtitlePadding,
              subtitleStyle: subtitleStyle,
              titleStyle: titleStyle,
              positiveAction: positiveAction,
              negativeAction: negativeAction,
              isDismissible: isDismissible,
              enableDrag: enableDrag,
              showBackButton: showBackButton,
              bottomSafeArea: bottomSafeArea,
              child: childBuilder != null ? childBuilder.call() : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }

  static Future<T?> showErrorThemeDynamic<T>(
    BuildContext context, {
    required String content,
    String? errorCode,
    bool useRootNavigator = false,
    TextStyle? contentStyle,
    double? maxHeight,
    bool isDismissible = true,
    bool showCloseButton = false,
    bool enableDrag = true,
    bool bottomSafeArea = true,
    bool showOutlinedButton = false,
    String? outlinedButtonText,
    Function()? onOutlinedButtonPressed,
    bool showFilledButton = false,
    String? filledButtonText,
    Function()? onFilledButtonPressed,
    String? customImagePath = '',
    bool isSuccess = false,
    bool isCritical = false,
    String? title,
    bool showBackButton = false,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: context.pColorScheme.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        minWidth: MediaQuery.sizeOf(context).width,
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(Grid.m),
              topLeft: Radius.circular(Grid.m),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: ColoredBox(
            color: context.pColorScheme.backgroundColor,
            child: PBottomSheet(
              title: title ?? '',
              isDismissible: isDismissible,
              enableDrag: enableDrag,
              showBackButton: showBackButton,
              bottomSafeArea: bottomSafeArea,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Grid.m,
                  bottom: !bottomSafeArea ? Grid.m : EdgeInsets.zero.bottom,
                ),
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        customImagePath!.isNotEmpty
                            ? customImagePath
                            : isSuccess
                                ? DesignImagesPath.check_circle
                                : DesignImagesPath.alert_circle,
                        height: 52,
                        width: 52,
                        package: 'design_system',
                        colorFilter: ColorFilter.mode(
                          isCritical ? context.pColorScheme.critical : context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      Text(
                        content,
                        textAlign: TextAlign.center,
                        style: contentStyle ?? context.pAppStyle.labelReg16textPrimary,
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      if (errorCode != null && errorCode.isNotEmpty)
                        Text(
                          errorCode,
                          textAlign: TextAlign.center,
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      if (showOutlinedButton || showFilledButton)
                        SizedBox(
                          height: 52,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              if (showOutlinedButton)
                                Expanded(
                                  child: POutlinedButton(
                                    text: outlinedButtonText ?? '',
                                    variant: isCritical ? PButtonVariant.error : PButtonVariant.brand,
                                    onPressed: () => onOutlinedButtonPressed?.call(),
                                  ),
                                ),
                              if (showOutlinedButton && showFilledButton)
                                const SizedBox(
                                  width: Grid.s,
                                ),
                              if (showFilledButton)
                                Expanded(
                                  child: PButton(
                                    text: filledButtonText ?? '',
                                    variant: isCritical ? PButtonVariant.error : PButtonVariant.brand,
                                    onPressed: () => onFilledButtonPressed?.call(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PBottomSheetGreyHeader extends StatelessWidget {
  const PBottomSheetGreyHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      width: 44.0,
      child: Container(
        decoration: BoxDecoration(
          color: context.pColorScheme.iconPrimary.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(Grid.xs)),
        ),
      ),
    );
  }
}

class PBottomSheetAction {
  final String text;
  final VoidCallback? action;

  PBottomSheetAction({required this.text, required this.action});
}
