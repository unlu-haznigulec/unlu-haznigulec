import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/model/potential_profit_loss_model.dart';
import 'package:piapiri_v2/app/profit/widgets/potential_profit_loss_detail_list.dart';
import 'package:piapiri_v2/app/profit/widgets/profit_loss_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PotentialProfitLossList extends StatelessWidget {
  final List<OverallItemGroups>? overallItemGroups;
  const PotentialProfitLossList({
    super.key,
    this.overallItemGroups,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: overallItemGroups?.length ?? 0,
      itemBuilder: (context, index) {
        if (overallItemGroups![index].instrumentCategory == 'cash') {
          return const SizedBox.shrink();
        }

        return InkWell(
          onTap: () {
            PBottomSheet.show(
              context,
              title: L10n.tr('potential_profit_loss'),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                ),
                child: PotentialProfitLossDetailList(
                  overallItemList: overallItemGroups?[index].overallItems,
                  type: overallItemGroups?[index].instrumentCategory ?? '',
                ),
              ),
            );
          },
          child: ProfitLossRow(
            title: L10n.tr(
              'portfolio.${overallItemGroups![index].instrumentCategory!}',
            ),
            value: overallItemGroups![index].totalPotentialProfitLoss ?? 0.0,
            iconName: ImagesPath.chevron_right,
          ),
        );
      },
    );
  }
}
