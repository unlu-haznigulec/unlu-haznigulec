import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/string_utils.dart';

class ButtonCatalogPage extends StatefulWidget {
  const ButtonCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ButtonCatalogPageCatalogPageState();
}

class _ButtonCatalogPageCatalogPageState extends State<ButtonCatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Button catalog'),
      body: ListView(
        children: <Widget>[
          ...PButtonVariant.values.map((variant) {
            return getButtonWidgets(variant, true);
          }).toList(),
          getButtonWidgets(null, false),
          const SizedBox(
            height: Grid.s,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: Text(
              'Icon Buttons',
              style: context.pAppStyle.interRegularBase.copyWith(color: context.pColorScheme.darkHigh),
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          ...PIconButtonType.values.map((type) {
            return getIconButtons(type, true);
          }).toList(),
          ...PIconButtonType.values.map((type) {
            return getIconButtons(type, false);
          }).toList(),
        ],
      ),
    );
  }

  String getText(String text) {
    final List<String> splits = text.split('.');
    if (splits.length > 1) {
      StringUtils.capitalize(splits[1]);
    }
    return '';
  }

  Widget getIconButtons(PIconButtonType type, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Grid.m, vertical: Grid.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEnabled ? getText(type.toString()) : 'Disabled ${getText(type.toString())}',
            style: context.pAppStyle.interMediumBase.copyWith(
              color: context.pColorScheme.darkHigh,
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          Wrap(
            spacing: Grid.s,
            runSpacing: Grid.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: PIconButtonSize.values.map(
              (size) {
                return PIconButton(
                  type: type,
                  icon: Icons.close,
                  sizeType: size,
                  color: context.pColorScheme.darkHigh,
                  onPressed: isEnabled ? () {} : null,
                );
              },
            ).toList(),
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
      ),
    );
  }

  Widget getButtonWidgets(PButtonVariant? variant, bool isEnabled) {
    final Color headingTextColor =
        variant == PButtonVariant.ghost ? context.pColorScheme.lightHigh : context.pColorScheme.darkHigh;
    return Container(
      color: variant == PButtonVariant.ghost ? context.pColorScheme.darkHigh : context.pColorScheme.lightHigh,
      padding: const EdgeInsets.symmetric(horizontal: Grid.m, vertical: Grid.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            variant != null ? getText(variant.toString()) : 'Disabled',
            style: context.pAppStyle.interRegularBase.copyWith(
              color: headingTextColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Grid.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filled',
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m + Grid.xxs,
                    color: headingTextColor,
                  ),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Wrap(
                  spacing: Grid.s,
                  runSpacing: Grid.xs,
                  children: PButtonSize.values.map((size) {
                    return PButton(
                      text: variant != null ? 'Enabled' : 'Disabled',
                      variant: variant ?? PButtonVariant.brand,
                      sizeType: size,
                      onPressed: isEnabled ? () {} : null,
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                Text(
                  'Outlined',
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m + Grid.xxs,
                    color: headingTextColor,
                  ),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Wrap(
                  spacing: Grid.s,
                  runSpacing: Grid.xs,
                  children: PButtonSize.values.map((size) {
                    return POutlinedButton(
                      text: variant != null ? 'Enabled' : 'Disabled',
                      variant: variant ?? PButtonVariant.brand,
                      sizeType: size,
                      onPressed: isEnabled ? () {} : null,
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                Text(
                  'Text',
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m + Grid.xxs,
                    color: headingTextColor,
                  ),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Wrap(
                  spacing: Grid.s,
                  runSpacing: Grid.xs,
                  children: PButtonSize.values.map((size) {
                    return PTextButton(
                      text: variant != null ? 'Enabled' : 'Disabled',
                      variant: variant ?? PButtonVariant.brand,
                      sizeType: size,
                      onPressed: isEnabled ? () {} : null,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
