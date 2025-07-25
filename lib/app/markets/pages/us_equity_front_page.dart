import 'package:design_system/components/chip/chip.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/markets/widgets/us_symbol_dividend_carousel_widget.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_gainers.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_losers.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_populer.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_volumes.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

class UsEquityFrontPage extends StatefulWidget {
  const UsEquityFrontPage({super.key});

  @override
  State<UsEquityFrontPage> createState() => _UsEquityFrontPageState();
}

class _UsEquityFrontPageState extends State<UsEquityFrontPage> {
  late UsEquityBloc _usEquityBloc;
  late ScrollController _chipScrollController;

  final List<String> _categories = [
    'high',
    'low',
    'volume',
    'populers',
  ];

  String _subcribeKey = 'high';

  @override
  void initState() {
    _usEquityBloc = getIt<UsEquityBloc>();
    _chipScrollController = ScrollController();

    if (_usEquityBloc.state.gainers.isEmpty) {
      _usEquityBloc.add(GetLosersGainersEvent(number: 5));
    }

    if (_usEquityBloc.state.favoriteIncomingDividends.isEmpty) {
      _usEquityBloc.add(GetUsIncomingDividends(isFavorite: true));
    }

    if (_usEquityBloc.state.allIncomingDividends.isEmpty) {
      _usEquityBloc.add(GetUsIncomingDividends(isFavorite: false));
    }

    super.initState();
  }

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: Grid.m,
              right: Grid.m,
              top: Grid.m,
            ),
            child: Text(
              L10n.tr('highlights'),
              style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m + Grid.xxs,
              ),
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          Container(
            height: Grid.l + Grid.m,
            alignment: Alignment.center,
            child: ListView.builder(
              controller: _chipScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              itemBuilder: (context, index) {
                final key = _categories[index];
                return Row(
                  children: [
                    PChoiceChip(
                      label: L10n.tr('usEquityStats.$key'),
                      selected: _subcribeKey == key,
                      chipSize: ChipSize.medium,
                      enabled: true,
                      onSelected: (_) {
                        setState(() {
                          _subcribeKey = key;
                          switch (key) {
                            case 'high':
                            case 'low':
                              if (_usEquityBloc.state.gainers.isEmpty || _usEquityBloc.state.losers.isEmpty) {
                                _usEquityBloc.add(GetLosersGainersEvent(number: 5));
                              }
                              break;
                            case 'volume':
                              if (_usEquityBloc.state.volumes.isEmpty) {
                                _usEquityBloc.add(
                                  GetVolumesEvent(number: 5),
                                );
                              }
                              break;
                            case 'populers':
                              if (_usEquityBloc.state.populers.isEmpty) {
                                _usEquityBloc.add(
                                  GetPopulersEvent(number: 5),
                                );
                              }
                              break;
                          }
                        });

                        // Scroll to selected chip
                        _chipScrollController.animateTo(
                          index * 100.0, // yaklaşık genişlik
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    const SizedBox(width: Grid.xs),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          PBlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: _usEquityBloc,
            builder: (context, state) {
              switch (_subcribeKey) {
                case 'high':
                  return UsGainers(
                    list: state.gainers,
                    count: 5,
                  );
                case 'low':
                  return UsLosers(
                    list: state.losers,
                    count: 5,
                  );
                case 'volume':
                  return UsVolumes(
                    list: state.volumes,
                    count: 5,
                  );
                case 'populers':
                  return UsPopuler(
                    list: state.populers,
                    count: 5,
                  );
                default:
                  return UsGainers(list: state.gainers.take(5).toList());
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PCustomOutlinedButtonWithIcon(
              text: L10n.tr(
                _subcribeKey == 'high'
                    ? 'high.show_all_symbols'
                    : _subcribeKey == 'low'
                        ? 'low.show_all_symbols'
                        : _subcribeKey == 'volume'
                            ? 'volume.show_all_symbols'
                            : 'populer.show_all_symbols',
              ),
              iconSource: ImagesPath.arrow_up_right,
              buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
              onPressed: () {
                if (_subcribeKey == 'high' || _subcribeKey == 'low') {
                  router.push(
                    UsLosersGainersRoute(isLosers: _subcribeKey == 'low'),
                  );
                } else {
                  router.push(
                    UsVolumePopulerRoute(isVolume: _subcribeKey == 'volume'),
                  );
                }
              },
            ),
          ),

          /// Yakında Temettü Dağıtacaklar
          BlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: _usEquityBloc,
            builder: (context, state) {
              bool isLoading = state.favoriteIncomingDividendsState == PageState.loading ||
                  state.allIncomingDividendsState == PageState.loading;

              if (isLoading) {
                return const Padding(
                  padding: EdgeInsets.only(
                    top: Grid.l,
                  ),
                  child: PLoading(),
                );
              }

              if (state.allIncomingDividends.isEmpty && state.favoriteIncomingDividends.isEmpty) {
                return const SizedBox.shrink();
              }

              return UsSymbolDividendCarouselWidget(
                symbolList: state.favoriteIncomingDividends.isNotEmpty == true
                    ? state.favoriteIncomingDividends
                    : state.allIncomingDividends,
              );
            },
          ),
        ],
      ),
    );
  }
}
