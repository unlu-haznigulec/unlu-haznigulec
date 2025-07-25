import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ComponentsTileWidget extends StatelessWidget {
  final String instrumentCategory;
  final OverallSubItemModel overallSubItems;
  final bool isDefaultParity;
  final double totalUsdOverall;
  final double totalAmount;
  final int index;
  final int lastIndex;
  final bool isVisible;
  final double scrollPadding;
  const ComponentsTileWidget({
    super.key,
    required this.instrumentCategory,
    required this.overallSubItems,
    required this.isDefaultParity,
    required this.totalUsdOverall,
    required this.totalAmount,
    required this.index,
    required this.lastIndex,
    required this.isVisible,
    required this.scrollPadding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: instrumentCategory == 'sgmk' ||
              (instrumentCategory == 'currency' &&
                  overallSubItems.symbol != 'USD') //TODO: currency bir enuma vs eklenecek
          ? null
          : () {
              if (stringToSymbolType(instrumentCategory) == SymbolTypes.fund) {
                router.push(
                  FundDetailRoute(
                    fundCode: overallSubItems.financialInstrumentCode ?? '',
                  ),
                );
              } else if (instrumentCategory == 'currency' && overallSubItems.symbol == 'USD') {
                router.push(
                  CurrencyBuySellRoute(
                    currencyType: CurrencyEnum.dollar,
                    accountsByCurrency: UserModel.instance.accounts
                        .where(
                          (element) => element.currency == CurrencyEnum.dollar,
                        )
                        .toList(),
                  ),
                );
              } else {
                _goDetailPage(
                  symbol: stringToSymbolType(instrumentCategory) == SymbolTypes.option ||
                          stringToSymbolType(instrumentCategory) == SymbolTypes.future
                      ? overallSubItems.symbol.split(' ').first
                      : stringToSymbolType(instrumentCategory) == SymbolTypes.warrant &&
                                  overallSubItems.symbol ==
                                      'AIYAA' || //TODO: dbBistcode düzenlemesi sonrasında burası revize edilecek
                              overallSubItems.symbol == 'AGXAA' ||
                              overallSubItems.symbol == 'ADAAB'
                          ? '${overallSubItems.symbol}C'
                          : stringToSymbolType(instrumentCategory) == SymbolTypes.warrant
                              ? '${overallSubItems.symbol}V'
                              : overallSubItems.symbol == 'ALTIN'
                                  ? '${overallSubItems.symbol}S1'
                                  : overallSubItems.symbol,
                  type: instrumentCategory,
                );
              }
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (instrumentCategory != 'Mevduat') ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: Grid.xxs,
                ),
                child: SymbolIcon(
                  key: Key('Portfolio_Category:${instrumentCategory}_Symbol:${overallSubItems.symbol}'),
                  symbolName: instrumentCategory == 'currency'
                      ? '${overallSubItems.symbol}TRY'
                      : stringToSymbolType(instrumentCategory) == SymbolTypes.fund ||
                              stringToSymbolType(instrumentCategory) == SymbolTypes.option ||
                              stringToSymbolType(instrumentCategory) == SymbolTypes.future ||
                              stringToSymbolType(instrumentCategory) == SymbolTypes.warrant
                          ? overallSubItems.underlying
                          : overallSubItems.symbol == 'ALTIN'
                              ? '${overallSubItems.symbol}S1'
                              : overallSubItems.symbol,
                  symbolType:
                      instrumentCategory == 'currency' ? SymbolTypes.parity : stringToSymbolType(instrumentCategory),
                  size: 30,
                ),
              ),
              const SizedBox(width: Grid.s),
            ],
            SizedBox(
              //ekran widthi - padding , iconsize,
              width: MediaQuery.sizeOf(context).width - Grid.m * 2 - 30 - Grid.s - scrollPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //1.satır
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: instrumentCategory != 'Mevduat'
                              ? MediaQuery.sizeOf(context).width / 2
                              : MediaQuery.sizeOf(context).width - Grid.m * 2 - 30 - Grid.s - scrollPadding,
                        ),
                        child: Text(
                          textAlign: TextAlign.start,
                          instrumentCategory == SymbolTypes.fund.name
                              ? overallSubItems.financialInstrumentCode!
                              : stringToSymbolType(instrumentCategory) == SymbolTypes.future
                                  ? '${splitAndCleanString(overallSubItems.symbol)['beforeSpace'] ?? overallSubItems.symbol} •'
                                  : overallSubItems.symbol,
                          maxLines: instrumentCategory != 'Mevduat' ? 1 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                      ),
                      if (instrumentCategory != 'Mevduat') ...[
                        const SizedBox(
                          width: Grid.xs,
                        ),
                        if (stringToSymbolType(instrumentCategory) == SymbolTypes.future) ...[
                          Text(
                            StringUtils.capitalize(splitAndCleanString(overallSubItems.symbol)['afterSpace'] ?? ''),
                            style: context.pAppStyle.interMediumBase.copyWith(
                              fontSize: Grid.s + Grid.xs,
                              color: splitAndCleanString(overallSubItems.symbol)['afterSpace'] == 'LONG'
                                  ? context.pColorScheme.success
                                  : context.pColorScheme.critical,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                        ],
                        if (instrumentCategory != 'viop' && instrumentCategory != 'sgmk') ...[
                          Text(
                            '${'(%${MoneyUtils().readableMoney(
                              (overallSubItems.price * overallSubItems.qty * 100) / totalAmount,
                            )}'})',
                            style: context.pAppStyle.labelReg12textSecondary,
                          ),
                        ],
                        const Spacer(),
                        Text(
                          '${isVisible ? MoneyUtils().readableMoney(overallSubItems.qty) : '**'} ${L10n.tr('adet')} ',
                          style: context.pAppStyle.labelReg12textPrimary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(
                    height: Grid.xxs,
                  ),

                  //2.satır
                  if (instrumentCategory != 'sgmk' && instrumentCategory != 'Mevduat') ...[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        instrumentCategory == 'viop'
                            ? Text(
                                isDefaultParity
                                    ? isVisible
                                        ? '${L10n.tr('settlement_price')}: ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                            overallSubItems.price,
                                            pattern: '#,##0.####',
                                          )}'
                                        : '${CurrencyEnum.turkishLira.symbol}**'
                                    : isVisible
                                        ? '${L10n.tr('settlement_price')}: ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                            overallSubItems.price / totalUsdOverall,
                                            pattern: '#,##0.####',
                                          )}'
                                        : '${CurrencyEnum.dollar.symbol}**',
                                style: context.pAppStyle.labelMed12textSecondary,
                              )
                            : Row(
                                children: [
                                  Text(
                                    isDefaultParity
                                        ? isVisible
                                            ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                                overallSubItems.price,
                                              )}'
                                                .formatNegativePriceAndPercentage()
                                            : '${CurrencyEnum.turkishLira.symbol}**'
                                        : isVisible
                                            ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                                overallSubItems.price / totalUsdOverall,
                                              )}'
                                                .formatNegativePriceAndPercentage()
                                            : '${CurrencyEnum.dollar.symbol}**',
                                    style: context.pAppStyle.labelMed12textSecondary,
                                  ),
                                  const SizedBox(
                                    width: Grid.s,
                                  ),
                                  if (instrumentCategory != 'currency') ...[
                                    SvgPicture.asset(
                                      overallSubItems.profitLossPercent > 0
                                          ? ImagesPath.trending_up
                                          : overallSubItems.profitLossPercent < 0
                                              ? ImagesPath.trending_down
                                              : ImagesPath.trending_notr,
                                      height: Grid.m - Grid.xxs,
                                      colorFilter: ColorFilter.mode(
                                        overallSubItems.profitLossPercent > 0
                                            ? context.pColorScheme.success
                                            : overallSubItems.profitLossPercent < 0
                                                ? context.pColorScheme.critical
                                                : context.pColorScheme.iconPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Text(
                                      isVisible
                                          ? '%${MoneyUtils().readableMoney(
                                              overallSubItems.profitLossPercent,
                                            )}'
                                              .formatNegativePriceAndPercentage()
                                          : '%**',
                                      style: context.pAppStyle.labelMed12textPrimary.copyWith(
                                        color: overallSubItems.profitLossPercent == 0
                                            ? context.pColorScheme.textPrimary
                                            : overallSubItems.profitLossPercent > 0
                                                ? context.pColorScheme.success
                                                : context.pColorScheme.critical,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (instrumentCategory != 'viop') ...[
                              Text(
                                '${L10n.tr('toplam')}: ',
                                style: context.pAppStyle.labelMed12textPrimary,
                              ),
                            ],
                            Text(
                              isDefaultParity
                                  ? isVisible
                                      ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                          instrumentCategory == 'viop'
                                              ? getIt<AssetsBloc>().state.portfolioViop?.totalAmount ?? 0
                                              : overallSubItems.amount,
                                          pattern: instrumentCategory == 'viop' ? '#,##0.00##' : '#,##0.00',
                                        )} '
                                      : '${CurrencyEnum.turkishLira.symbol}**'
                                  : isVisible
                                      ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                          instrumentCategory == 'viop'
                                              ? (getIt<AssetsBloc>().state.portfolioViop?.totalAmount ?? 0) /
                                                  totalUsdOverall
                                              : overallSubItems.amount / totalUsdOverall,
                                          pattern: instrumentCategory == 'viop' ? '#,##0.00##' : '#,##0.00',
                                        )} '
                                      : '${CurrencyEnum.dollar.symbol}**',
                              style: context.pAppStyle.labelMed12textPrimary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(
                    height: Grid.xxs,
                  ),

                  //3.satır
                  if (instrumentCategory != 'Mevduat' && instrumentCategory != 'currency') ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isDefaultParity
                              ? '${L10n.tr('maliyet')}: ${isVisible ? '₺${MoneyUtils().readableMoney(
                                  overallSubItems.cost,
                                  pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                )}' : '${CurrencyEnum.turkishLira.symbol}**'}'
                              : '${L10n.tr('maliyet')}: ${isVisible ? '\$${MoneyUtils().readableMoney(
                                  overallSubItems.cost / totalUsdOverall,
                                  pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                )}' : '${CurrencyEnum.dollar.symbol}**'}',
                          style: context.pAppStyle.labelReg12textSecondary,
                        ),
                        const Spacer(),
                        if (instrumentCategory != 'sgmk') ...[
                          if (instrumentCategory == 'viop') ...[
                            Text(
                              '${L10n.tr('profitLossSymbol')}:',
                              style: context.pAppStyle.labelMed12textSecondary.copyWith(
                                fontSize: Grid.l / 2 - Grid.xxs / 2,
                                color: overallSubItems.profitLossPercent == 0
                                    ? context.pColorScheme.iconPrimary
                                    : overallSubItems.profitLossPercent > 0
                                        ? context.pColorScheme.success
                                        : context.pColorScheme.critical,
                              ),
                            ),
                            const SizedBox(
                              width: Grid.xxs,
                            ),
                          ],
                          if (instrumentCategory != 'viop') ...[
                            Utils().profitLossPercentWidget(
                              context: context,
                              performance: overallSubItems.profitLossPercent,
                              fontSize: Grid.l / 2 - Grid.xxs / 2,
                              isVisible: isVisible,
                            ),
                          ],
                          Text(
                            isDefaultParity
                                ? isVisible
                                    ? ' (${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                        overallSubItems.potentialProfitLoss,
                                        // pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                      )})'
                                        .formatNegativePriceAndPercentage()
                                    : ' (${CurrencyEnum.turkishLira.symbol}**)'
                                : isVisible
                                    ? ' (${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                        overallSubItems.potentialProfitLoss / totalUsdOverall,
                                        pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                      )})'
                                        .formatNegativePriceAndPercentage()
                                    : ' (${CurrencyEnum.dollar.symbol}**)',
                            style: context.pAppStyle.labelMed12primary.copyWith(
                              color: overallSubItems.potentialProfitLoss == 0
                                  ? context.pColorScheme.textPrimary
                                  : overallSubItems.potentialProfitLoss > 0
                                      ? context.pColorScheme.success
                                      : context.pColorScheme.critical,
                              fontSize: Grid.l / 2 - Grid.xxs / 2,
                            ),
                          ),
                        ],
                      ],
                    ),
                    //4.satır
                    if (instrumentCategory == 'viop') ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${L10n.tr('instantProfitlossSymbol')}:',
                            style: context.pAppStyle.labelMed12textSecondary.copyWith(
                              fontSize: Grid.l / 2 - Grid.xxs / 2,
                              color: overallSubItems.instantPotentialProfitLoss == 0
                                  ? context.pColorScheme.iconPrimary
                                  : (overallSubItems.instantPotentialProfitLoss) > 0
                                      ? context.pColorScheme.success
                                      : context.pColorScheme.critical,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xxs,
                          ),
                          Text(
                            isDefaultParity
                                ? isVisible
                                    ? '(${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                        overallSubItems.instantPotentialProfitLoss,
                                      )})'
                                        .formatNegativePriceAndPercentage()
                                    : '(${CurrencyEnum.turkishLira.symbol}**)'
                                : isVisible
                                    ? '(${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                        overallSubItems.instantPotentialProfitLoss / totalUsdOverall,
                                      )})'
                                        .formatNegativePriceAndPercentage()
                                    : '(${CurrencyEnum.dollar.symbol}**)',
                            style: context.pAppStyle.labelMed12primary.copyWith(
                              color: overallSubItems.instantPotentialProfitLoss == 0
                                  ? context.pColorScheme.textPrimary
                                  : overallSubItems.instantPotentialProfitLoss > 0
                                      ? context.pColorScheme.success
                                      : context.pColorScheme.critical,
                              fontSize: Grid.l / 2 - Grid.xxs / 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, String> splitAndCleanString(String input) {
  List<String> parts = input.split(' ');
  String beforeSpace = parts[0];
  String afterSpace = parts[1].replaceAll('(', '').replaceAll(')', '');
  return {
    'beforeSpace': beforeSpace,
    'afterSpace': afterSpace,
  };
}

void _goDetailPage({required String symbol, required String type}) {
  getIt<SymbolBloc>().add(
    SymbolIsExistInDBEvent(
      symbol: symbol,
      symbolTypes: stringToSymbolType(type),
      hasInDB: (isExist, symbolName) {
        if (isExist && symbolName != 'Cari') {
          //db'de yoksa sembol detaya göndermiyorum
          router.push(
            SymbolDetailRoute(
              symbol: MarketListModel(
                symbolCode: symbolName,
                updateDate: '',
                type: type,
              ),
            ),
          );
        }
      },
    ),
  );
}
