import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/widgets/price_alarm_last_price_widget.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AlarmTile extends StatelessWidget {
  final BaseAlarm alarm;
  final bool fromPriceAlarm;
  final String symbolType;
  final String underlyingName;
  final bool hasDivider;
  final bool showCurrentPrice;
  final String? subTitle;
  final double? height;
  final double horizontalPadding;
  final String? description;

  const AlarmTile({
    super.key,
    required this.alarm,
    this.fromPriceAlarm = false,
    required this.symbolType,
    required this.underlyingName,
    this.hasDivider = true,
    this.showCurrentPrice = true,
    this.subTitle,
    this.height,
    this.horizontalPadding = Grid.m,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey<String>(alarm.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.32,
        children: [
          const Spacer(),
          LayoutBuilder(
            builder: (context, constraints) => SlideOptions(
              height: constraints.maxHeight,
              imagePath: ImagesPath.trash,
              backgroundColor: context.pColorScheme.critical,
              iconColor: context.pColorScheme.lightHigh,
              onTap: () => _showDeleteAlert(context), // Kullanıcıya Silme alertini gösterdiğimiz yer.,
            ),
          ),
        ],
      ),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SymbolIcon(
              symbolName: stringToSymbolType(symbolType) == SymbolTypes.option ||
                      stringToSymbolType(symbolType) == SymbolTypes.future ||
                      stringToSymbolType(symbolType) == SymbolTypes.warrant
                  ? underlyingName
                  : alarm.symbol,
              symbolType: stringToSymbolType(symbolType),
              size: 28,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alarm.symbol,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                      if (description != null)
                        Text(
                          description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                    ],
                  ),
                  if (subTitle != null)
                    Text.rich(
                      TextSpan(
                        text: subTitle!,
                        style: context.pAppStyle.labelMed12textSecondary,
                        children: [
                          WidgetSpan(
                            child: Baseline(
                              baselineType: TextBaseline.alphabetic,
                              baseline: -5, // Text'i ortalaması için verilen değer
                              child: Text(
                                ' • ',
                                style: context.pAppStyle.labelReg14textSecondary.copyWith(
                                  fontSize: Grid.s + Grid.xxs,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: L10n.tr(stringToSymbolType(symbolType).filter?.localization ?? ''),
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            if (showCurrentPrice) ...[
              const SizedBox(
                width: Grid.s,
              ),
              if (alarm is PriceAlarm)
                PriceAlarmLastPriceWidget(
                  symbol: alarm.symbol,
                ),
            ],
            if (alarm is PriceAlarm)
              Expanded(
                child: Text(
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney((alarm as PriceAlarm).price)}',
                  textAlign: TextAlign.end,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              )
          ],
        ),
      ),
    );
  }

  void _showDeleteAlert(BuildContext context) {
    PBottomSheet.show(
      context,
      title: L10n.tr(
        'delete_news_alarm',
        args: [
          fromPriceAlarm ? L10n.tr('fiyat') : L10n.tr('new_title'),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            ImagesPath.alertCircle,
            width: 52,
            height: 52,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            L10n.tr(
              fromPriceAlarm ? 'delete_price_alarm_warning' : 'delete_alarm_warning',
              args: [
                alarm.symbol,
              ],
            ),
            style: context.pAppStyle.labelReg16textPrimary,
          ),
          const SizedBox(
            height: Grid.l,
          ),
          Row(
            children: [
              Expanded(
                child: POutlinedButton(
                  text: L10n.tr('vazgec'),
                  fillParentWidth: true,
                  sizeType: PButtonSize.medium,
                  onPressed: () {
                    router.maybePop();
                  },
                ),
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Expanded(
                child: PButton(
                  text: L10n.tr('onayla'),
                  fillParentWidth: true,
                  onPressed: () async {
                    getIt<AlarmBloc>().add(
                      RemoveAlarmEvent(
                        id: alarm.id,
                        callback: () {
                          getIt<AlarmBloc>().add(
                            GetAlarmsEvent(),
                          );
                        },
                      ),
                    );

                    await router.maybePop();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
