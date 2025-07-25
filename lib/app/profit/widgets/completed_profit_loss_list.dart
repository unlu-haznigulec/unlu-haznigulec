import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/model/tax_detail_model.dart';
import 'package:piapiri_v2/app/profit/widgets/completed_profit_loss_detail_list.dart';
import 'package:piapiri_v2/app/profit/widgets/profit_loss_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CompletedProfitLossList extends StatelessWidget {
  final List<TaxDetails> taxDetails;
  const CompletedProfitLossList({
    super.key,
    required this.taxDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: taxDetails.length,
        itemBuilder: (context, index) {
          if (taxDetails[index].totalPrice == 0) {
            return const SizedBox.shrink();
          }

          return InkWell(
            splashColor: context.pColorScheme.transparent,
            highlightColor: context.pColorScheme.transparent,
            onTap: () {
              if (taxDetails[index].taxDetails == null) {
                return;
              }

              PBottomSheet.show(
                context,
                title: L10n.tr('completed_profit_loss'),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                  ),
                  child: CompletedProfitLossDetailList(
                    taxDetailList: taxDetails[index].taxDetails!,
                  ),
                ),
              );
            },
            child: ProfitLossRow(
              title: taxDetails[index].finType ?? '',
              value: taxDetails[index].totalPrice ?? 0.0,
              iconName: ImagesPath.chevron_right,
            ),
          );
        });
  }
}
