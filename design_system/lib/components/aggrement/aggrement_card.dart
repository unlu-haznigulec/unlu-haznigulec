import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';

class PAggrementCard extends StatelessWidget {
  // final ReconciliationModel reconciliation;
  final Function() onTap;
  final String? testText;
  const PAggrementCard({
    super.key,
    // required this.reconciliation,
    required this.onTap,
    this.testText,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 180,
      ),
      child: SizedBox(
        // decoration: BlueBoxDecoration().pBlueBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(Grid.m),
          child: _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    const String date = '';

    // if (reconciliation.periodStartDate != null && reconciliation.periodStartDate!.isNotEmpty) {
    //   date = '${date + DateTime.parse(
    //         reconciliation.periodStartDate ?? DateTime.now().toString(),
    //       ).formatDayMonthYearDot()} - ';
    // }
    // if (reconciliation.periodEndDate != null && reconciliation.periodEndDate!.isNotEmpty) {
    //   date = date +
    //       DateTime.parse(
    //         reconciliation.periodEndDate ?? DateTime.now().toString(),
    //       ).formatDayMonthYearDot();
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          //'$date ${Utils.tr('dated_agreement')}',
          testText ?? date,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: context.pColorScheme.lightMedium,
              ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                // Utils.tr(
                //   reconciliation.periodId == 'daily_agreements_period_id'
                //       ? 'daily_reconciliation_description'
                //       : 'period_reconciliation_description',
                // ),
                'daily_reconciliation_description',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: context.pColorScheme.lightMedium,
                    ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            PTextButton(
              text: 'mutabakat_yap',
              onPressed: onTap,
            ),
          ],
        ),
      ],
    );
  }
}
