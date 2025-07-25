import 'package:collection/collection.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

class IpoLastPriceWidget extends StatefulWidget {
  final IpoModel ipo;
  final String symbol;
  final bool showIpoPrice;
  const IpoLastPriceWidget({
    super.key,
    required this.ipo,
    required this.symbol,
    this.showIpoPrice = true,
  });

  @override
  State<IpoLastPriceWidget> createState() => _IpoLastPriceWidgetState();
}

class _IpoLastPriceWidgetState extends State<IpoLastPriceWidget> {
  late SymbolBloc _symbolBloc;
  MarketListModel? _selectedItem;
  String _symbolName = '';

  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _symbolName = (widget.symbol.contains('.HE') ? widget.symbol.replaceAll('.HE', '') : widget.symbol).trim();
    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: _symbolName,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) =>
          previous.type != current.type &&
          (current.type == PageState.updated || current.type == PageState.success) &&
          current.watchingItems.map((e) => e.symbolCode).toList().contains(_symbolName),
      listener: (context, state) {
        MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == _symbolName,
        );
        if (newModel == null) return;
        setState(() {
          _selectedItem = newModel;
        });
      },
      builder: (context, state) {
        if (_selectedItem == null) {
          return Text(
            L10n.tr('demand_is_gathering'),
            style: context.pAppStyle.labelReg14primary.copyWith(fontWeight: FontWeight.bold),
          );
        }

        if (state.isFetching) {
          const PLoading();
        }

        double oldPrice = 0.0;
        double totalChange = 0.0;
        String startPrice = '';
        String endPrice = '';

        if (widget.ipo.startPrice != null) {
          oldPrice = widget.ipo.startPrice!;

          if (widget.ipo.endPrice == null) {
            startPrice = MoneyUtils().readableMoney(widget.ipo.startPrice!);
          } else {
            startPrice = MoneyUtils().readableMoney(widget.ipo.startPrice!);
          }
        }

        if (widget.ipo.endPrice != null) {
          endPrice = '-${MoneyUtils().readableMoney(widget.ipo.endPrice!)}';
        }

        totalChange = ((_selectedItem!.last / oldPrice) * 100) - 100;

        String percentageTotalChange = MoneyUtils().readableMoney(totalChange);

        if (percentageTotalChange.contains('-')) {
          percentageTotalChange = percentageTotalChange.replaceAll('-', '-%');
        } else {
          percentageTotalChange = '%$percentageTotalChange';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.showIpoPrice) ...[
              Text(
                widget.ipo.startDate != null && widget.ipo.endDate != null
                    ? '${L10n.tr('ipo_price')}: ₺$startPrice$endPrice'
                    : L10n.tr('ipo_application_process'),
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              const SizedBox(
                height: Grid.xxs,
              ),
            ],
            Text(
              '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_selectedItem!.last)}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            const SizedBox(
              height: Grid.xxs,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  totalChange > 0 ? ImagesPath.trending_up : ImagesPath.trending_down,
                  width: Grid.m,
                  height: Grid.m,
                  colorFilter: ColorFilter.mode(
                    totalChange > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: Grid.xxs / 4,
                ),
                Text(
                  percentageTotalChange,
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m - Grid.xxs,
                    color: totalChange > 0 ? context.pColorScheme.success : context.pColorScheme.critical,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
