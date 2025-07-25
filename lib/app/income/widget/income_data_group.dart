import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/balance/widget/balance_data_sub_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/p_expandable_panel.dart';

class IncomeDataGroup extends StatefulWidget {
  final String title;
  final double value;
  final List contentList;
  const IncomeDataGroup({
    super.key,
    required this.title,
    required this.value,
    required this.contentList,
  });

  @override
  State<IncomeDataGroup> createState() => _IncomeDataGroupState();
}

class _IncomeDataGroupState extends State<IncomeDataGroup> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return PExpandablePanel(
      initialExpanded: _isExpanded,
      isExpandedChanged: (isExpanded) => setState(() {
        _isExpanded = isExpanded;
      }),
      titleBuilder: (isExpanded) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              widget.title,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '₺${MoneyUtils().compactMoney(widget.value)}'.trim(),
            style: context.pAppStyle.labelMed16textPrimary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          SvgPicture.asset(
            isExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
            height: 12,
            width: 12,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.textPrimary,
              BlendMode.srcIn,
            ),
          )
        ],
      ),
      child: Column(
        children: widget.contentList
            .map((e) => Column(
                  children: [
                    BalanceDataSubRow(title: e['description'], value: e['value'].toDouble()),
                    const SizedBox(
                      height: Grid.xxs,
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
