import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/dropdown/dropdown_model.dart';
import 'package:design_system/components/dropdown/dropdown_widget.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';

class DropdownCatalogPage extends StatefulWidget {
  const DropdownCatalogPage({super.key});

  @override
  State<DropdownCatalogPage> createState() => _DropdownCatalogPageState();
}

class _DropdownCatalogPageState extends State<DropdownCatalogPage> {
  DropDownCatalogEnum selectedTestEnum = DropDownCatalogEnum.test1;

  @override
  Widget build(BuildContext context) {
    final Color fontColor = context.pColorScheme.primary.shade700;

    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Dropdown catalog'),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          DropdownWidget<DropDownCatalogEnum>(
            title: 'Test',
            titleColor: fontColor,
            iconColor: fontColor,
            isExpanded: true,
            selectedValue: selectedTestEnum,
            titleTextStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: fontColor,
                ),
            items: dropdownList
                .map<DropdownModel>(
                  (e) => DropdownModel(
                    name: e['title'],
                    value: e['value'],
                  ),
                )
                .toList(),
            onChanged: (value, String name) {
              setState(() {
                selectedTestEnum = value;
              });
            },
            selectedWidget: Text(
              dropdownList.firstWhere((element) => element['value'] == selectedTestEnum)['title'],
              style: TextStyle(
                color: fontColor,
              ),
            ),
            titleSuffixIcon: SizedBox(
              height: 15,
              width: 22,
              child: IconButton(
                splashRadius: 1,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.help_rounded,
                  size: 22,
                  color: fontColor,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> dropdownList = [
  {
    'value': DropDownCatalogEnum.test1,
    'title': 'test1',
    'description': 'test1',
  },
  {
    'value': DropDownCatalogEnum.test2,
    'title': 'test2',
    'description': 'test2',
  },
  {
    'value': DropDownCatalogEnum.test3,
    'title': 'test3',
    'description': 'test3',
  },
  {
    'value': DropDownCatalogEnum.test4,
    'title': 'test4',
    'description': 'test4',
  },
];

enum DropDownCatalogEnum {
  test1('test1'),
  test2('test2'),
  test3('test3'),
  test4('test4');

  const DropDownCatalogEnum(this.value);
  final String value;
}
