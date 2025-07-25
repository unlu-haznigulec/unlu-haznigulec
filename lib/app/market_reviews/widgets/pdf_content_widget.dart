import 'package:design_system/components/chip/chip.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/share_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class PdfContentWidget extends StatelessWidget {
  final ReportModel reportModel;
  final Widget bodyWidget;
  final String title;
  final String mainGroup;
  const PdfContentWidget({
    super.key,
    required this.reportModel,
    required this.bodyWidget,
    required this.title,
    required this.mainGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: title,
        actions: [
          ShareIcon(
            reportModel: reportModel,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Grid.s,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              reportModel.title,
              textAlign: TextAlign.left,
              style: context.pAppStyle.labelMed16textPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              DateTimeUtils.dateFormat(
                DateTime.parse(reportModel.dateTime),
              ),
              style: context.pAppStyle.labelMed14textSecondary,
            ),
          ),
          _symbolList(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: bodyWidget,
            ),
          ),
        ],
      ),
    );
  }

  Widget _symbolList(BuildContext context) {
    if (reportModel.symbols.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 30,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: Grid.m,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: reportModel.symbols.length,
        itemBuilder: (context, index) {
          String symbolName = reportModel.symbols[index];

          if (mainGroup == MarketTypeEnum.marketFund.value) {
            if (reportModel.institutionCodeSymbolMap != null) {
              symbolName =
                  reportModel.institutionCodeSymbolMap![reportModel.symbols[index]] ?? reportModel.symbols[index];
            }
          }

          String svgPath =
              '${getIt<AppInfo>().cdnUrl}icons/${symbolTypeToCdnHandle(mainGroup == MarketTypeEnum.marketUs.value ? SymbolTypes.foreign : mainGroup == MarketTypeEnum.marketFund.value ? SymbolTypes.fund : SymbolTypes.equity)}/$symbolName.svg';

          return PSymbolChip(
            label: reportModel.symbols[index],
            chipSize: ChipSize.small,
            svgPath: svgPath,
            isForeign: mainGroup == MarketTypeEnum.marketUs.value,
            onPressed: () {
              if (mainGroup == MarketTypeEnum.marketUs.value) {
                router.push(
                  SymbolUsDetailRoute(
                    symbolName: reportModel.symbols[index],
                  ),
                );
              } else if (mainGroup == MarketTypeEnum.marketFund.value) {
                router.push(
                  FundDetailRoute(
                    fundCode: reportModel.symbols[index],
                  ),
                );
              } else {
                getIt<SymbolBloc>().add(
                  SymbolDetailPageEvent(
                    symbolData: MarketListModel(
                      symbolCode: reportModel.symbols[index],
                      updateDate: DateTime.now().toString(),
                      type: SymbolTypes.equity.name,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
