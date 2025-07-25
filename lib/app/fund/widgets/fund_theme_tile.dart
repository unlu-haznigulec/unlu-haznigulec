import 'package:cached_network_image/cached_network_image.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/model/fund_themes_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/capital_fallback.dart';
import 'package:piapiri_v2/core/cache_managers/symbol_icon_cache_manager.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';

class FundThemeTile extends StatelessWidget {
  final FundThemesModel fundTheme;

  const FundThemeTile({
    super.key,
    required this.fundTheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getIt<FundBloc>().add(
          SetFilterEvent(
            fundFilter: FundFilterModel(
              institution: '',
              institutionName: '',
              themeId: fundTheme.themeId,
            ),
            callback: (list) {},
          ),
        );
        router.push(
          FundsListRoute(
            title: fundTheme.themeName,
            fromSectors: true,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: Grid.s,
        ),
        child: SizedBox(
          width: 112,
          child: Column(
            spacing: Grid.xs,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  Grid.s,
                ),
                child: CachedNetworkImage(
                  width: 112,
                  height: 72,
                  cacheManager: SymbolIconCacheManager(),
                  imageUrl: fundTheme.cdnUrl,
                  placeholder: (context, url) => CircularProgressIndicator(
                    color: context.pColorScheme.primary,
                  ),
                  errorWidget: (context, url, error) {
                    return CapitalFallback(
                      symbolName: fundTheme.themeName,
                      size: 72,
                    );
                  },
                  fadeInDuration: const Duration(
                    milliseconds: 500,
                  ),
                ),
              ),
              Text(
                fundTheme.themeName,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelMed14textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
