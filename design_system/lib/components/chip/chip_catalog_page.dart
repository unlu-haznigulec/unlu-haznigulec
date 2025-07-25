import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/chip/chip.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class ChipCatalogPage extends StatefulWidget {
  const ChipCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChipCatalogPageState();
}

class _ChipCatalogPageState extends State<ChipCatalogPage> {
  final List<bool> inputTypeValues = List.generate(3, (index) => true);
  final List<bool> inputWithIconTypeValues = List.generate(3, (index) => true);
  final List<bool> filterTypeValues = List.generate(3, (index) => true);
  final List<bool> choiceTypeValues = List.generate(3, (index) => true);
  final List<bool> avatarTypeValues = List.generate(3, (index) => true);
  bool chipValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pColorScheme.lightHigh,
      appBar: const PAppBarCoreWidget(title: 'Chip catalog'),
      body: ListView(
        padding: const EdgeInsets.all(Grid.m),
        children: [
          Text('Input Type', style: context.pAppStyle.interRegularBase),
          Text('Input Type', style: context.pAppStyle.interRegularBase),
          const SizedBox(
            height: Grid.s,
          ),
          Row(
            children: [
              Flexible(
                child: ListView.separated(
                  itemCount: inputTypeValues.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return PInputChip(
                      label: 'New Design',
                      selected: inputTypeValues[i],
                      onSelected: (value) {
                        setState(() {
                          inputTypeValues[i] = value;
                        });
                      },
                      chipSize: ChipSize.values[i],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ),
              ),
              Flexible(
                child: ListView.separated(
                  itemCount: inputTypeValues.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return PInputChip(
                      label: 'New Design',
                      selected: inputTypeValues[i],
                      showDeleteIcon: false,
                      onSelected: (value) {
                        setState(() {
                          inputTypeValues[i] = value;
                        });
                      },
                      chipSize: ChipSize.values[i],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text('Input with icon Type', style: context.pAppStyle.interRegularBase),
          const SizedBox(
            height: Grid.s,
          ),
          Row(
            children: [
              Flexible(
                child: ListView.separated(
                  itemCount: inputWithIconTypeValues.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return PInputWithIconChip(
                      iconData: Icons.verified_user,
                      label: 'New Design',
                      selected: inputWithIconTypeValues[i],
                      onSelected: (value) {
                        setState(() {
                          inputWithIconTypeValues[i] = value;
                        });
                      },
                      chipSize: ChipSize.values[i],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ),
              ),
              Flexible(
                child: ListView.separated(
                  itemCount: inputWithIconTypeValues.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return PInputWithIconChip(
                      iconData: Icons.verified_user,
                      label: 'New Design',
                      selected: inputWithIconTypeValues[i],
                      onSelected: (value) {
                        setState(() {
                          inputWithIconTypeValues[i] = value;
                        });
                      },
                      chipSize: ChipSize.values[i],
                      showDeleteIcon: false,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text('Filter Type', style: context.pAppStyle.interRegularBase),
          const SizedBox(
            height: Grid.s,
          ),
          ListView.separated(
            itemCount: inputWithIconTypeValues.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) {
              return PFilterChip(
                label: 'New Design',
                selected: filterTypeValues[i],
                onSelected: (value) {
                  setState(() {
                    filterTypeValues[i] = value;
                  });
                },
                chipSize: ChipSize.values[i],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text('Choice Type', style: context.pAppStyle.interRegularBase),
          const SizedBox(
            height: Grid.s,
          ),
          ListView.separated(
            itemCount: choiceTypeValues.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) {
              return PChoiceChip(
                label: 'New Design',
                selected: choiceTypeValues[i],
                onSelected: (value) {
                  setState(() {
                    choiceTypeValues[i] = value;
                  });
                },
                chipSize: ChipSize.values[i],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text('Avatar Type', style: context.pAppStyle.interRegularBase),
          const SizedBox(
            height: Grid.s,
          ),
          Row(
            children: [
              Flexible(
                child: ListView.separated(
                  itemCount: avatarTypeValues.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return PAvatarChip(
                      avatar: const AssetImage('res/assets/images/mood-4.png', package: 'design_system'),
                      label: 'New Design',
                      selected: avatarTypeValues[i],
                      onSelected: (value) {
                        setState(() {
                          avatarTypeValues[i] = value;
                        });
                      },
                      chipSize: ChipSize.values[i],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ),
              ),
              Flexible(
                child: ListView.separated(
                  itemCount: avatarTypeValues.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return PAvatarChip(
                      avatar: const AssetImage('res/assets/images/mood-4.png', package: 'design_system'),
                      label: 'New Design',
                      selected: avatarTypeValues[i],
                      onSelected: (value) {
                        setState(() {
                          avatarTypeValues[i] = value;
                        });
                      },
                      chipSize: ChipSize.values[i],
                      showDeleteIcon: false,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
