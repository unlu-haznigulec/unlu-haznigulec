import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/model/fund_financial_founder_list_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class FundFoundersTile extends StatelessWidget {
  final GetFinancialFounderListModel institution;

  const FundFoundersTile({
    super.key,
    required this.institution,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        router.push(
          FundFoundersDetailRoute(
            institution: institution,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: Grid.s,
        ),
        child: Column(
          spacing: Grid.xs,
          children: [
            RectangleSymbolIcon(
              symbolName: institution.code ?? '',
              symbolType: SymbolTypes.fund,
              size: 72,
            ),
            SizedBox(
              width: 72,
              child: Text(
                institution.name ?? '',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelMed14textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
