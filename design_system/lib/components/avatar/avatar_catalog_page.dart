import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/avatar/avatar.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class AvatarCatalogPage extends StatelessWidget {
  const AvatarCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBarCoreWidget(title: 'Avatar catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: <Widget>[
          Text('Simple text avatar:', style: context.pAppStyle.interRegularBase),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              const PTextAvatar(text: 'DN'),
              const SizedBox(width: Grid.s),
              Text(
                '40x40',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              PTextAvatar(
                text: 'DN',
                width: 64,
                textStyle: context.pAppStyle.interRegularBase.copyWith(color: context.pColorScheme.lightHigh),
              ),
              const SizedBox(width: Grid.s),
              Text(
                '64x64',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              PTextAvatar(
                text: 'DN',
                width: 128,
                textStyle: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: 34,
                  color: context.pColorScheme.lightHigh,
                ),
              ),
              const SizedBox(width: Grid.s),
              Text(
                '128x128',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Divider(height: Grid.s, color: context.pColorScheme.stroke.shade700),
          const SizedBox(height: Grid.m),
          Text('Simple text avatar with non-default values:', style: context.pAppStyle.interRegularBase),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              PTextAvatar(
                text: 'DN',
                textStyle: context.pAppStyle.labelReg14primary,
                width: Grid.l,
                color: context.pColorScheme.iconPrimary.shade200,
              ),
              const SizedBox(width: Grid.s),
              Text(
                '24x24',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Divider(height: Grid.s, color: context.pColorScheme.stroke.shade700),
          const SizedBox(height: Grid.m),
          Text('Image avatar:', style: context.pAppStyle.interRegularBase),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              const PImageAvatar(
                imageUrl:
                    'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
                text: 'DN',
              ),
              const SizedBox(width: Grid.s),
              Text(
                '40x40',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              const PImageAvatar(
                imageUrl:
                    'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
                text: 'DN',
                width: 64,
              ),
              const SizedBox(width: Grid.s),
              Text(
                '64x64',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              const PImageAvatar(
                imageUrl:
                    'https://png.pngtree.com/thumb_back/fw800/back_our/20190619/ourmid/pngtree-cute-doctor-cartoon-medical-doctors-day-advertisement-background-image_141631.jpg',
                text: 'DN',
                width: 128,
              ),
              const SizedBox(width: Grid.s),
              Text(
                '128x128',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Divider(height: Grid.s, color: context.pColorScheme.stroke.shade700),
          const SizedBox(height: Grid.m),
          Row(
            children: <Widget>[
              const PImageAvatar(text: 'DN'),
              const SizedBox(width: Grid.s),
              Text(
                '40x40',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              PImageAvatar(
                text: 'DN',
                width: 64,
                textStyle: context.pAppStyle.interRegularBase.copyWith(color: context.pColorScheme.lightHigh),
              ),
              const SizedBox(width: Grid.s),
              Text(
                '64x64',
                style: context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
          Row(
            children: <Widget>[
              PImageAvatar(
                text: 'DN',
                width: 128,
                textStyle: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: 34,
                  color: context.pColorScheme.lightHigh,
                ),
              ),
              const SizedBox(width: Grid.s),
              Text(
                '128x128',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                ),
              ),
            ],
          ),
          const SizedBox(height: Grid.s),
        ],
      ),
    );
  }
}
