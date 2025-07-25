import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/symbol_list_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_model.dart';

//Amerikan borsası -> portfolio -> list list tile
class UsPortfolioDetailTile extends StatefulWidget {
  final USSymbolModel? symbol;
  final QuickPortfolioAssetModel item;

  const UsPortfolioDetailTile({
    super.key,
    required this.symbol,
    required this.item,
  });

  @override
  State<UsPortfolioDetailTile> createState() => _UsPortfolioDetailTileState();
}

class _UsPortfolioDetailTileState extends State<UsPortfolioDetailTile> {
  double _differencePercent = 0;
  @override
  void initState() {
    differencePercent();
    super.initState();
  }

  differencePercent() {
    if (widget.symbol != null) {
      _differencePercent = ((widget.symbol!.trade!.price! - widget.symbol!.previousDailyBar!.close!) /
              widget.symbol!.previousDailyBar!.close!) *
          100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      onTap: () {
        router.push(
          SymbolUsDetailRoute(
            symbolName: widget.item.code,
          ),
        );
      },
      child: SymbolListTile(
        symbolName: widget.item.founderCode ?? 'UNP',
        symbolType: SymbolTypes.foreign,
        leadingText: widget.item.code,
        subLeadingText: '${widget.item.founderName}',
        infoText: '%${MoneyUtils().readableMoney(widget.item.ratio)}',
        trailingWidget: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              _differencePercent > 0
                  ? ImagesPath.trending_up
                  : _differencePercent < 0
                      ? ImagesPath.trending_down
                      : ImagesPath.trending_notr,
              height: Grid.m,
              colorFilter: ColorFilter.mode(
                _differencePercent > 0
                    ? context.pColorScheme.success
                    : _differencePercent < 0
                        ? context.pColorScheme.critical
                        : context.pColorScheme.iconPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: Grid.xxs),
            Text(
              '%${MoneyUtils().readableMoney(_differencePercent)}',
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m - Grid.xxs,
                color: _differencePercent > 0
                    ? context.pColorScheme.success
                    : _differencePercent < 0
                        ? context.pColorScheme.critical
                        : context.pColorScheme.iconPrimary,
              ),
            ),
          ],
        ),
        onTap: () {
          router.push(
            SymbolUsDetailRoute(
              symbolName: widget.item.code,
            ),
          );
        },
      ),
    );
  }
}
