import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/selection_control/checkbox.dart';
import 'package:design_system/components/selection_control/filter_chip.dart';
import 'package:design_system/components/selection_control/option_scale.dart';
import 'package:design_system/components/selection_control/radio_button.dart';
import 'package:design_system/components/switch_tile/switch.dart';
import 'package:design_system/components/switch_tile/switch_tile.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class SelectionControlCatalogPage extends StatefulWidget {
  const SelectionControlCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectionControlCatalogPageState();
}

class _SelectionControlCatalogPageState extends State<SelectionControlCatalogPage> {
  bool _checkboxValue = false;
  bool _switchValue = false;
  int radioValue = 1;
  double _regularStarOptionScaleValue = 1;
  double _draggableHalfStarOptionScaleValue = 1;
  double _emojiOptionScaleValue = 1;
  double _numericalOptionScaleValue = 1;
  int _npsValue = 1;
  final List<bool> _filterChipsSelectionStatuses = [true, false, false, false];
  final List<bool> _filterChipListSelectionStatuses = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Selection control catalog'),
      body: ListView(
        children: <Widget>[
          PCheckboxRow(
            label: 'Enabled checkbox',
            value: _checkboxValue,
            onChanged: (bool? value) {
              setState(() {
                _checkboxValue = value ?? false;
              });
            },
          ),
          const SizedBox(height: Grid.m),
          const PCheckboxRow(
            label: 'Disabled selected checkbox',
            value: true,
          ),
          const SizedBox(height: Grid.m),
          const PCheckboxRow(
            label: 'Disabled deselected checkbox',
            value: false,
          ),
          const SizedBox(height: Grid.m),
          PSwitchRow(
            text: 'Enabled switch',
            value: _switchValue,
            onChanged: (bool value) {
              setState(() {
                _switchValue = value;
              });
            },
          ),
          const SizedBox(height: Grid.m),
          PSwitchRow(
            text: 'Disabled selected switch',
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: Grid.m),
          PSwitchRow(
            text: 'Disabled deselected switch',
            value: false,
            onChanged: (_) {},
          ),
          const SizedBox(height: Grid.m),
          PRadioButtonRow<int>(
            text: 'Radio button',
            value: 1,
            groupValue: radioValue,
            onChanged: (int? value) {
              setState(() {
                radioValue = value ?? 1;
              });
            },
          ),
          const SizedBox(height: Grid.m),
          PRadioButtonRow<int>(
            text: 'Radio button',
            value: 2,
            groupValue: radioValue,
            onChanged: (int? value) {
              setState(() {
                radioValue = value ?? 2;
              });
            },
          ),
          const SizedBox(height: Grid.m),
          const PRadioButtonRow<int>(
            text: 'Disabled selected radio button',
            value: 1,
            groupValue: 1,
          ),
          const SizedBox(height: Grid.m),
          const PRadioButtonRow<int>(
            text: 'Disabled deselected radio button',
            value: 1,
            groupValue: 2,
          ),
          const SizedBox(height: Grid.m),
          Text(
            'Filter Chips',
            style: context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.s),
            child: Wrap(
              runSpacing: Grid.s,
              spacing: Grid.s,
              children: [
                PFilterChip(
                  label: 'ALL',
                  isSelected: _filterChipsSelectionStatuses[0],
                  onSelected: (bool isSelected) {
                    if (_filterChipsSelectionStatuses[0] != true) {
                      setState(() {
                        _filterChipsSelectionStatuses[0] = isSelected;
                        _filterChipsSelectionStatuses.setAll(1, [!isSelected, !isSelected, !isSelected]);
                      });
                    }
                  },
                ),
                PFilterChip(
                  label: 'OPTION 1',
                  isSelected: _filterChipsSelectionStatuses[1],
                  onSelected: (bool isSelected) {
                    setState(() {
                      _filterChipsSelectionStatuses[1] = isSelected;
                      _filterChipsSelectionStatuses[0] == true
                          ? _filterChipsSelectionStatuses[0] = false
                          : _filterChipsSelectionStatuses[0] = false;
                    });
                  },
                ),
                PFilterChip(
                  label: 'OPTION 2',
                  isSelected: _filterChipsSelectionStatuses[2],
                  onSelected: (bool isSelected) {
                    setState(() {
                      _filterChipsSelectionStatuses[2] = isSelected;
                      _filterChipsSelectionStatuses[0] == true
                          ? _filterChipsSelectionStatuses[0] = false
                          : _filterChipsSelectionStatuses[0] = false;
                    });
                  },
                ),
                PFilterChip(
                  label: 'OPTION 3',
                  isSelected: _filterChipsSelectionStatuses[3],
                  onSelected: (bool isSelected) {
                    setState(() {
                      _filterChipsSelectionStatuses[3] = isSelected;
                      _filterChipsSelectionStatuses[0] == true
                          ? _filterChipsSelectionStatuses[0] = false
                          : _filterChipsSelectionStatuses[0] = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: Grid.s, right: Grid.s, top: Grid.m),
            child: Text(
              'Filter Chip List',
              style: context.pAppStyle.interRegularBase.copyWith(fontSize: Grid.m),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.s),
            child: PFilterChipList(
              children: ['first', 'second', 'third']
                  .asMap()
                  .map(
                    (index, label) {
                      return MapEntry(
                        index,
                        PFilterChip(
                          label: label.toUpperCase(),
                          isSelected: _filterChipListSelectionStatuses[index],
                          onSelected: (bool selected) {
                            setState(() {
                              _filterChipListSelectionStatuses[index] = selected;
                            });
                          },
                        ),
                      );
                    },
                  )
                  .values
                  .toList(),
            ),
          ),
          const SizedBox(height: Grid.xl),
          Text(
            'Without text',
            style: context.pAppStyle.interRegularBase,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Grid.m),
          Wrap(
            children: <Widget>[
              PCheckbox(
                value: _checkboxValue,
                onChanged: (bool? value) {
                  setState(() {
                    _checkboxValue = value ?? false;
                  });
                },
              ),
              const PCheckbox(
                value: true,
              ),
              const PCheckbox(
                value: false,
              ),
              PSwitch(
                value: _switchValue,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
              PSwitch(
                value: true,
                onChanged: (_) {},
              ),
              PSwitch(
                value: false,
                onChanged: (_) {},
              ),
              PRadioButton<int>(
                value: 1,
                groupValue: radioValue,
                onChanged: (int? value) {
                  setState(() {
                    radioValue = value ?? 1;
                  });
                },
              ),
              PRadioButton<int>(
                value: 2,
                groupValue: radioValue,
                onChanged: (int? value) {
                  setState(() {
                    radioValue = value ?? 2;
                  });
                },
              ),
              const PRadioButton<int>(
                value: 1,
                groupValue: 1,
              ),
              const PRadioButton<int>(
                value: 1,
                groupValue: 2,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Star Option Scale',
                  style: context.pAppStyle.interRegularBase,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Grid.m),
                POptionScale(
                  rating: _regularStarOptionScaleValue,
                  onRatingChanged: (int index) {
                    setState(() {
                      _regularStarOptionScaleValue = index + 1;
                    });
                  },
                ),
                const SizedBox(height: Grid.m),
                Text(
                  'Draggable Half Star Enabled Option Scale',
                  style: context.pAppStyle.interRegularBase,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Grid.m),
                POptionScale(
                  rating: _draggableHalfStarOptionScaleValue,
                  allowDragRate: true,
                  allowHalfRating: true,
                  onRatingChanged: (int index) {
                    setState(() {
                      _draggableHalfStarOptionScaleValue = index + 1;
                    });
                  },
                ),
                const SizedBox(height: Grid.m),
                Text(
                  'Emoji Option Scale',
                  style: context.pAppStyle.interRegularBase,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Grid.m),
                POptionScale(
                  rating: _emojiOptionScaleValue,
                  scaleType: ScaleType.emoji,
                  onRatingChanged: (int index) {
                    setState(() {
                      _emojiOptionScaleValue = index + 1;
                    });
                  },
                ),
                const SizedBox(height: Grid.m),
                Text(
                  'Numerical Option Scale',
                  style: context.pAppStyle.interRegularBase,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Grid.m),
                POptionScale(
                  rating: _numericalOptionScaleValue,
                  scaleType: ScaleType.numerical,
                  onRatingChanged: (int index) {
                    setState(() {
                      _numericalOptionScaleValue = index.toDouble();
                    });
                  },
                ),
                const SizedBox(height: Grid.m),
                Text(
                  'NPS Scale',
                  style: context.pAppStyle.interRegularBase,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Grid.m),
                PNpsScale(
                  rating: _npsValue,
                  onRatingChanged: (int rating) {
                    setState(() {
                      _npsValue = rating;
                    });
                  },
                ),
                const SizedBox(height: Grid.m),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
