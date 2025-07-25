import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/model/fund_themes_model.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_theme_tile.dart';
import 'package:piapiri_v2/common/widgets/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundThemesWidget extends StatelessWidget {
  const FundThemesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FundBloc, FundState>(
      bloc: getIt<FundBloc>(),
      builder: (context, state) {
        if (state.fundThemeList == null || state.fundThemeList!.isEmpty) {
          return NoDataWidget(
            message: L10n.tr('no_data'),
          );
        }

        int total = state.fundThemeList!.length;

        // Eğer toplam 8 veya daha azsa, ilk 4 yukarı, kalan aşağı
        // Ama 8'den fazlaysa, yukarıya yarıdan fazlasını koy
        int topCount;

        if (total <= 4) {
          topCount = total; // Hepsi yukarı
        } else {
          topCount = (total / 2).ceil(); // Örn: 9 => 5 yukarı, 4 aşağı
        }

        List<FundThemesModel> topItems = state.fundThemeList!.take(topCount).toList();
        List<FundThemesModel> bottomItems = state.fundThemeList!.skip(topCount).toList();

        return Shimmerize(
          enabled: state.isLoading,
          child: Padding(
              padding: const EdgeInsets.only(
                left: Grid.m,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: topItems
                          .map(
                            (e) => FundThemeTile(
                              fundTheme: e,
                            ),
                          )
                          .toList(),
                    ),
                    if (bottomItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Grid.s + Grid.xs,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: bottomItems
                              .map(
                                (e) => FundThemeTile(
                                  fundTheme: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
