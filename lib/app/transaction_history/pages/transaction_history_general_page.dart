import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/sliding_segment/model/sliding_segment_item.dart';
import 'package:design_system/components/sliding_segment/sliding_segment.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/model/portfolio_action_enum.dart';
import 'package:piapiri_v2/app/transaction_history/pages/transaction_history_abroad_page.dart';
import 'package:piapiri_v2/app/transaction_history/pages/transaction_history_domestic_page.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class TransactionHistoryGeneralPage extends StatefulWidget {
  const TransactionHistoryGeneralPage({
    super.key,
  });

  @override
  State<TransactionHistoryGeneralPage> createState() => _TransactionHistoryGeneralPageState();
}

class _TransactionHistoryGeneralPageState extends State<TransactionHistoryGeneralPage> {
  PortfolioActionEnum _action = PortfolioActionEnum.domestic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('portfolio_transaction_history'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
          vertical: Grid.s,
        ),
        child: !Utils().canTradeAmericanMarket()
            ? const TransactionHistoryDomesticPage()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    width: MediaQuery.sizeOf(context).width,
                    child: SlidingSegment(
                      initialSelectedSegment: 0,
                      backgroundColor: context.pColorScheme.card,
                      segmentList: [
                        PSlidingSegmentItem(
                          segmentTitle: L10n.tr('domestic'),
                          segmentColor: context.pColorScheme.secondary,
                        ),
                        PSlidingSegmentItem(
                          segmentTitle: L10n.tr('abroad'),
                          segmentColor: context.pColorScheme.secondary,
                        ),
                      ],
                      onValueChanged: (baseType) {
                        setState(() {
                          _action = baseType == 0 ? PortfolioActionEnum.domestic : PortfolioActionEnum.abroad;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  Expanded(
                    child: _action == PortfolioActionEnum.domestic
                        ? const TransactionHistoryDomesticPage()
                        : const TransactionHistoryAbroadPage(),
                  ),
                ],
              ),
      ),
    );
  }
}
