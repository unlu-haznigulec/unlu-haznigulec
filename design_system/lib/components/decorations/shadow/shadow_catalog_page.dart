import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/decorations/shadow/shadow.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShadowCatalogPage extends StatefulWidget {
  const ShadowCatalogPage({super.key});

  @override
  State<ShadowCatalogPage> createState() => _ShadowCatalogPageState();
}

class _ShadowCatalogPageState extends State<ShadowCatalogPage> {
  late ShadowItem _selectedShadow;
  final List<ShadowItem> _shadowItems = <ShadowItem>[
    ShadowItem(text: 'Shadow level 0', shadowValue: PShadow.level_0),
    ShadowItem(text: 'Shadow level 1', shadowValue: PShadow.level_1),
    ShadowItem(text: 'Shadow level 2', shadowValue: PShadow.level_2),
    ShadowItem(text: 'Shadow level 3', shadowValue: PShadow.level_3),
  ];

  @override
  void initState() {
    super.initState();
    _selectedShadow = ShadowItem(text: 'Shadow level 0', shadowValue: PShadow.level_0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Shadow'),
      body: ListView(
        children: <Widget>[
          _shadow(_selectedShadow.text, _selectedShadow.shadowValue),
          const Divider(),
        ],
      ),
    );
  }

  Widget _shadow(String title, BoxShadow shadow) {
    return Container(
      color: context.pColorScheme.lightHigh,
      padding: const EdgeInsets.all(Grid.m),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
              height: lineHeight125,
            ),
          ),
          _shadowedContainer(shadow),
          const SizedBox(
            height: Grid.m,
          ),
          _shadowPicker(),
        ],
      ),
    );
  }

  Widget _shadowPicker() {
    return PTextButton(
      text: 'Pick shadow',
      onPressed: () => showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: _shadowItems
                .map(
                  (ShadowItem item) => CupertinoActionSheetAction(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: Grid.s),
                        Expanded(
                          child: Text(
                            item.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: context.pColorScheme.primary),
                          ),
                        ),
                        const SizedBox(width: 32),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedShadow = item;
                      });
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Container _shadowedContainer(BoxShadow shadow) {
    return Container(
      height: 100,
      width: 200,
      decoration: BoxDecoration(
        color: context.pColorScheme.lightHigh,
        borderRadius: BorderRadius.circular(Grid.xs),
        border: Border.all(color: context.pColorScheme.stroke.shade200),
        boxShadow: <BoxShadow>[
          shadow,
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Center(
        child: Text(
          'Shadowed Container',
          style: context.pAppStyle.interRegularBase.copyWith(
            fontSize: Grid.s + Grid.xs + Grid.xxs,
            height: lineHeight150,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ShadowItem {
  final String text;
  final BoxShadow shadowValue;

  ShadowItem({required this.text, required this.shadowValue});
}
