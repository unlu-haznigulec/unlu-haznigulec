import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_event.dart';
import 'package:piapiri_v2/core/cache_managers/symbol_icon_cache_manager.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/bloc_locator.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/model/theme_enum.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AppInfoBloc _bloc;
  late final MatriksBloc _matriksBloc;
  final double _logoHeight = 48.0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  _initialize() async {
    await _onCheckClearSymbolIconCacheManager();
    BlocLocator().connectWebSocket();
    _bloc = getIt<AppInfoBloc>();
    _matriksBloc = getIt<MatriksBloc>();
    _matriksBloc.add(
      MatriksGetDiscoEvent(
        callback: () {
          _matriksBloc.add(
            MatriksGetTopicsEvent(
              callback: () {
                _bloc.add(
                  InitEvent(
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error),
                        ),
                      );
                    },
                    onSuccess: (isFirstLaunch) {
                      _bloc.add(
                        InvalidateCacheEvent(),
                      );
                      _bloc.add(
                        SetAppThemeEvent(
                          appTheme: _bloc.state.appTheme,
                        ),
                      );
                      _bloc.add(
                        GetUpdatedRecords(
                          callback: () {},
                        ),
                      );
                      _bloc.add(
                        ReadLoginCountEvent(
                          callback: (loginCount) {
                            if (isFirstLaunch || loginCount.isEmpty) {
                              router.pushAndPopUntil(
                                CreateAccountRoute(
                                  isFirstLaunch: isFirstLaunch,
                                  goHomePage: true,
                                ),
                                predicate: (_) => false,
                              );
                            } else {
                              router.pushAndPopUntil(
                                AuthRoute(
                                  fromSplash: true,
                                ),
                                predicate: (_) => false,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _onCheckClearSymbolIconCacheManager() async {
    try {
      String symbolIconKey = AppConfig.instance.isProd ? 'symbolIconCachedDate_prod' : 'symbolIconCachedDate_dev';
      final String remoteDateJson = remoteConfig.getValue(symbolIconKey).asString();

      if (remoteDateJson.isEmpty) return;

      final String remoteDateStr = jsonDecode(remoteDateJson);
      final DateTime? remoteCachedDateParsed = DateTime.tryParse(remoteDateStr);

      if (remoteCachedDateParsed == null) return;

      final remoteCachedDate = DateTime(
        remoteCachedDateParsed.year,
        remoteCachedDateParsed.month,
        remoteCachedDateParsed.day,
        remoteCachedDateParsed.hour,
        remoteCachedDateParsed.minute,
      );

      final String? strLocalDate = getIt<LocalStorage>().read(symbolIconKey);
      bool isUpdate = strLocalDate == null;

      if (!isUpdate) {
        final DateTime? localCachedDateParsed = DateTime.tryParse(strLocalDate);
        if (localCachedDateParsed == null) {
          isUpdate = true;
        } else {
          final localCachedDate = DateTime(
            localCachedDateParsed.year,
            localCachedDateParsed.month,
            localCachedDateParsed.day,
            localCachedDateParsed.hour,
            localCachedDateParsed.minute,
          );

          if (remoteCachedDate.isAfter(localCachedDate)) {
            isUpdate = true;
          }
        }
      }

      if (isUpdate) {
        getIt<LocalStorage>().write(symbolIconKey, remoteDateStr);
        await SymbolIconCacheManager().emptyCache();
      }
    } catch (error) {
      log('found an error in onCheckClearSymbolIconCacheManager : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        left: false,
        right: false,
        child: Center(
          child: PBlocBuilder<AppSettingsBloc, AppSettingsState>(
            bloc: getIt<AppSettingsBloc>(),
            builder: (context, appSettingsState) => Shimmer.fromColors(
              baseColor: context.pColorScheme.textPrimary,
              highlightColor: appSettingsState.generalSettings.theme == ThemeEnum.light
                  ? context.pColorScheme.textPrimary.shade200
                  : context.pColorScheme.textPrimary.shade800,
              child: SizedBox(
                width: pageWidth * 0.5,
                height: _logoHeight,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    ImagesPath.darkPiapiriLoginLogo,
                    color: Theme.of(context).hoverColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
