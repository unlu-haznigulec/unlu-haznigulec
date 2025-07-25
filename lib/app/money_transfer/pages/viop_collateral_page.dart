import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/sliding_segment/model/sliding_segment_item.dart';
import 'package:design_system/components/sliding_segment/sliding_segment.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/money_transfer/pages/deposit_collateral_page.dart';
import 'package:piapiri_v2/app/money_transfer/pages/withdrawal_collateral_page.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ViopCollateralPage extends StatefulWidget {
  const ViopCollateralPage({super.key});

  @override
  State<ViopCollateralPage> createState() => _ViopCollateralPageState();
}

class _ViopCollateralPageState extends State<ViopCollateralPage> {
  int _selectedSegmentedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('portfolio.viop_collateral'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: Grid.l - Grid.xs,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 35,
              child: SlidingSegment(
                backgroundColor: context.pColorScheme.card,
                segmentList: [
                  PSlidingSegmentItem(
                    segmentTitle: L10n.tr('teminat_yatirma'),
                    segmentColor: context.pColorScheme.secondary,
                  ),
                  PSlidingSegmentItem(
                    segmentTitle: L10n.tr('teminat_cekme'),
                    segmentColor: context.pColorScheme.secondary,
                  ),
                ],
                onValueChanged: (index) {
                  setState(() {
                    _selectedSegmentedIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
            Expanded(
              child: _selectedSegmentedIndex == 0 ? const DepositCollateralPage() : const WithDrawalCollateralPage(),
            )
          ],
        ),
      ),
    );
  }
}
