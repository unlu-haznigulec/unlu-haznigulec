import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';

class TypographyCatalogPage extends StatelessWidget {
  const TypographyCatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Typography catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text(
            'Headline 1',
            style: context.pAppStyle.interMediumBase.copyWith(
              height: lineHeight125,
              fontSize: 64,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Headline 2',
            style: context.pAppStyle.interMediumBase.copyWith(
              height: lineHeight125,
              fontSize: 48,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Headline 3',
            style: context.pAppStyle.interMediumBase.copyWith(
              height: lineHeight125,
              fontSize: 40,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Headline 4',
            style: context.pAppStyle.interMediumBase.copyWith(
              height: lineHeight125,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Headline 5',
            style: context.pAppStyle.interMediumBase.copyWith(
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Headline 6',
            style: context.pAppStyle.interRegularBase.copyWith(height: lineHeight125),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Subtitle 1',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m,
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Subtitle 2',
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.s + Grid.xs + Grid.xxs,
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Body 1',
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.m,
              height: lineHeight150,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Body 2',
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs + Grid.xxs,
              height: lineHeight150,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Button',
            style: context.pAppStyle.interMediumBase.copyWith(
              height: lineHeight150,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Caption',
            style: context.pAppStyle.interRegularBase.copyWith(
              letterSpacing: 1,
              fontSize: Grid.s + Grid.xs,
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text('OVERLINE',
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.s + Grid.xs,
                letterSpacing: 1,
                height: lineHeight125,
              ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Label',
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs + Grid.xxs,
              height: lineHeight125,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Text(
            'Helper Text',
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.s + Grid.xs + Grid.xxs,
              height: lineHeight150,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
