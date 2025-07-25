import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/avatar/avatar.dart';
import 'package:design_system/components/list/list_item.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class ColorsCatalogPage extends StatelessWidget {
  const ColorsCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Colors catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Color Palette',
            style: context.pAppStyle.interRegularBase,
          ),
          const SizedBox(height: Grid.s),
          Text(
            'Primary',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade900), title: 'Primary900'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade800), title: 'Primary800'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade700), title: 'Primary700'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade600), title: 'Primary600'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade500), title: 'Primary500'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade400), title: 'Primary400'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade300), title: 'Primary300'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade200), title: 'Primary200'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.primary.shade100), title: 'Primary100'),
          const SizedBox(height: Grid.m),
          Text(
            'Secondary',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.secondary), title: 'Secondary'),
          const SizedBox(height: Grid.m),
          Text(
            'Card',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade900), title: 'Card900'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade800), title: 'Card800'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade700), title: 'Card700'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade600), title: 'Card600'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade500), title: 'Card500'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade400), title: 'Card400'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade300), title: 'Card300'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade200), title: 'Card200'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.card.shade100), title: 'Card100'),
          const SizedBox(height: Grid.m),
          Text(
            'Line',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade900), title: 'Line900'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade800), title: 'Line800'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade700), title: 'Line700'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade600), title: 'Line600'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade500), title: 'Line500'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade400), title: 'Line400'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade300), title: 'Line300'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade200), title: 'Line200'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.line.shade100), title: 'Line100'),
          const SizedBox(height: Grid.m),
          Text(
            'Grey',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          const PListItem(leading: PTextAvatar(), title: 'grey900'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade700), title: 'grey700'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade600), title: 'grey600'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade500), title: 'grey500'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade400), title: 'grey400'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade300), title: 'grey300'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade200), title: 'grey200'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade100), title: 'grey100'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.iconPrimary.shade50), title: 'grey50'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.lightHigh), title: 'grey0'),
          const SizedBox(height: Grid.m),
          Text(
            'Success',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade900), title: 'Success900'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade800), title: 'Success800'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade700), title: 'Success700'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade600), title: 'Success600'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade500), title: 'Success500'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade400), title: 'Success400'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade300), title: 'Success300'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade200), title: 'Success200'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade100), title: 'Success100'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.success.shade50), title: 'Success50'),
          const SizedBox(height: Grid.m),
          Text(
            'Warning',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade900), title: 'Warning900'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade800), title: 'Warning800'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade700), title: 'Warning700'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade600), title: 'Warning600'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade500), title: 'Warning500'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade400), title: 'Warning400'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade300), title: 'Warning300'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade200), title: 'Warning200'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade100), title: 'Warning100'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning.shade50), title: 'Warning50'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.warning), title: 'Warning25'),
          const SizedBox(height: Grid.m),
          Text(
            'Critical',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade900), title: 'Critical900'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade800), title: 'Critical800'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade700), title: 'Critical700'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade600), title: 'Critical600'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade500), title: 'Critical500'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade400), title: 'Critical400'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade300), title: 'Critical300'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade200), title: 'Critical200'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade100), title: 'Critical100'),
          PListItem(leading: PTextAvatar(color: context.pColorScheme.critical.shade50), title: 'Critical50'),
          const SizedBox(height: Grid.m),
          Text(
            'Text Colors',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
          const SizedBox(height: Grid.s),
          Text(
            'Darktext/high-emphasis',
            style: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.darkHigh,
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Darktext/medium-emphasis',
            style: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.darkMedium,
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Darktext/low-emphasis, disabled',
            style: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.darkLow,
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Lighttext/high-emphasis',
            style: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.lightHigh,
              height: lineHeight125,
              backgroundColor: context.pColorScheme.iconPrimary.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Lighttext/medium-emphasis',
            style: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.lightMedium,
              height: lineHeight125,
              backgroundColor: context.pColorScheme.iconPrimary.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Lighttext/low-emphasis, disabled',
            style: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.lightLow,
              height: lineHeight125,
              backgroundColor: context.pColorScheme.iconPrimary.shade900,
              decorationColor: context.pColorScheme.iconPrimary.shade900,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
