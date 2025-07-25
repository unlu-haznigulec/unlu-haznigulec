import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_bloc.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_event.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/money_transfer/model/bank_model.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_bloc.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/app_info/repository/app_info_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_event.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/service_locator_manager.dart';
import 'package:piapiri_v2/core/config/session_timer.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/app_settings.dart';
import 'package:piapiri_v2/core/model/precaution_model.dart';
import 'package:piapiri_v2/core/model/session_model.dart';
import 'package:piapiri_v2/core/model/us_time_model.dart';
import 'package:piapiri_v2/core/services/token_service.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AppInfoBloc extends PBloc<AppInfoState> {
  final AppInfoRepository _appInfoRepository;

  AppInfoBloc({required AppInfoRepository appInfoRepository})
      : _appInfoRepository = appInfoRepository,
        super(initialState: const AppInfoState()) {
    //TODO(taha): move events to separate file
    on<InitEvent>(_onInit);
    on<SetDeviceIdEvent>(_onSetDeviceId);
    on<SetAppThemeEvent>(_onSetAppTheme);
    on<GetUpdatedRecords>(_onGetUpdatedRecords); // db bloc
    on<ErrorAlertEvent>(_onErrorAlertEvent);
    on<SetMaxInstrumentCount>(_onSetMaxInstrumentCount); // symbol bloc
    on<InvalidateCacheEvent>(_onInvalidateCache); // profile bloc
    on<GetCautionListEvent>(_onGetCautionList);
    on<ChangeEnv>(_onChangeEnv);
    on<WriteHasMembershipEvent>(_onWriteHasMembership);
    on<ReadHasMembershipEvent>(_onReadHasMembership);
    on<ReadLoginCountEvent>(_onReadLoginCount);
    on<ReadShowAccountEvent>(_onReadShowCreateAccount);
    on<GetUSClockEvent>(_onGetUSClockEvent);
    on<ChangeSelectedMarketMenuEvent>(_onChangeSelectedMarketMenu);
    on<GetSessionHoursEvent>(_onGetSessionHours);
  }

  FutureOr<void> _onInit(
    InitEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    try {
      getIt<PPApi>().matriksService.deleteMatriksTokens();
      getIt<LocalStorage>().delete(LocalKeys.customerInfo);
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );

      final bool hasConnection = await InternetConnectionChecker().hasConnection;
      DatabaseHelper dbHelper = DatabaseHelper();

      dbHelper.cleanLogs();
      if (hasConnection) {
        bool healthCheck = remoteConfig.getBool('isServerHealthy');
        if (healthCheck) {
          getIt<TimeBloc>().add(TimeConnectEvent());
          int buildNumber = int.parse(getIt<AppInfo>().appVersion.split('+').last);
          RemoteConfigValue minBuildValue = remoteConfig.getValue('minBuild');
          int minBuild = jsonDecode(minBuildValue.asString())[PlatformUtils.isIos ? 'ios' : 'android'];
          final Completer<void> languageKeysCompleter = Completer<void>();
          getIt<LanguageBloc>().add(
            LanguageGetKeysEvent(
              onSuccess: () {
                languageKeysCompleter.complete();
              },
            ),
          );
          await languageKeysCompleter.future;
          getIt<AppSettingsBloc>().add(
            GetLocalGeneralSettingsEvent(
              onSuccess: (generalSettings) {
                getIt<LocalStorage>().write('lastLoginDate', DateTime.now().millisecondsSinceEpoch);
                getIt<LanguageBloc>().add(
                  LanguageSetEvent(
                    languageCode: generalSettings.language.value,
                  ),
                );
              },
            ),
          );
          final cdnUrl = json.decode(remoteConfig.getString('cdnUrl'));
          getIt<AppInfo>().cdnUrl = (AppConfig.instance.flavor == Flavor.dev ? cdnUrl['dev'] : cdnUrl['prod'])!;
          AppSettings deviceSettings = AppSettings();
          Map<String, String> memberShortNames = {};
          String deviceId = getIt<AppInfo>().deviceId;
          bool? isFirstTime = getIt<LocalStorage>().read(LocalKeys.firstOpen);
          if (isFirstTime == null || isFirstTime == true) {
            final ApiResponse firstOpenResponse = await _appInfoRepository.checkAppFirstOpen(deviceId);
            if (firstOpenResponse.success) {
              getIt<LocalStorage>().write(LocalKeys.firstOpen, false);
            }
          }

          add(
            ReadHasMembershipEvent(
              callback: (Map<dynamic, dynamic> hasMembership) async {
                if (hasMembership['status']) {
                  await getIt<NotificationHandler>().registerForNotifications();
                }
              },
            ),
          );

          getIt<Analytics>().setFirebaseUserProperties(
            customerId: '',
            deviceId: getIt<AppInfo>().deviceId,
          );
          ThemeMode appTheme = getIt<LocalStorage>().read(LocalKeys.appTheme) == null ||
                  getIt<LocalStorage>().read(LocalKeys.appTheme) == '1'
              ? ThemeMode.light
              : ThemeMode.dark;
          Map<String, dynamic> depositBankInfos = json.decode(remoteConfig.getString('bankInfos'));
          BankModel bankModel = BankModel.fromJson(depositBankInfos);
          bankModel.bankInfos?.sort((a, b) => a.id!.compareTo(b.id!));
          List<String> holidays = getIt<LocalStorage>().read(LocalKeys.holidays) ?? [];
          if (holidays.isEmpty || holidays.first.startsWith(DateTime.now().year.toString())) {
            ApiResponse holidaysResponse = await getIt<PPApi>().matriksService.getHolidays(
                  getIt<MatriksBloc>().state.endpoints!.rest!.holidays!.url!,
                );
            if (holidaysResponse.success) {
              holidays = List<String>.from(holidaysResponse.data);
              getIt<LocalStorage>().write(LocalKeys.holidays, holidays);
            }
          }
          ApiResponse priceStepsResponse = await getIt<PPApi>().appInfoService.getPriceSteps();
          Map<String, dynamic> viopPriceSteps = AppConfig.instance.flavor == Flavor.dev
              ? jsonDecode(remoteConfig.getString('DevViopPriceSteps'))
              : jsonDecode(remoteConfig.getString('ViopPriceSteps'));
          Map<String, dynamic> priceSteps = {};
          if (priceStepsResponse.success) {
            List<dynamic> completeSteps = priceStepsResponse.data.map((steps) => steps['values']).toList();
            List<dynamic> flatSteps = completeSteps.expand((e) => e).toList();
            for (Map<String, dynamic> steps in flatSteps) {
              priceSteps.addAll(
                {steps['symbolType'] ?? steps['submarketCode']: steps['PriceRanges']},
              );
            }
          }

          if (priceSteps['SSF'] == null) {
            priceSteps['SSF'] = viopPriceSteps['SSF'];
          }

          Future.microtask(() {
            getIt<CreateUsOrdersBloc>().add(GetComissionEvent());
            getIt<SymbolSearchBloc>().add(GetSymbolSortEvent());
            getIt<SectorsBloc>().add(GetBistSectorsEvent());
            getIt<FavoriteListBloc>().add(GetQuickListEvent());
            getIt<SymbolBloc>().add(GetMarketCarouselEvent());
            getIt<CampaignsBloc>().add(GetCampaignIsAvailable());
            add(GetUSClockEvent());
          });

          ApiResponse codesResponse = await _appInfoRepository.fetchMemberCodes(
            getIt<MatriksBloc>().state.endpoints!.rest!.metaData!.members!.url ?? '',
          );
          if (codesResponse.success) {
            for (var memberCode in codesResponse.data) {
              memberShortNames[memberCode['memberCode']] =
                  (memberCode['shortName'] ?? memberCode['description'].toString().split(' ')[0]).toString();
            }
          }
          add(GetSessionHoursEvent());
          emit(
            state.copyWith(
              type: PageState.success,
              deviceId: deviceId,
              appTheme: appTheme,
              deviceSettings: deviceSettings,
              memberCodeShortNames: memberShortNames,
              holidays: holidays,
              priceSteps: priceSteps,
              bankModel: bankModel,
            ),
          );
          if (buildNumber >= minBuild) {
            add(GetCautionListEvent());
            event.onSuccess(isFirstTime ?? true);
          } else {
            PBottomSheet.showError(
              NavigatorKeys.navigatorKey.currentContext!,
              customImagePath: ImagesPath.warningOrange,
              isDismissible: false,
              enableDrag: false,
              content: L10n.tr('should_update'),
              showFilledButton: true,
              filledButtonText: L10n.tr('guncelle'),
              onFilledButtonPressed: () async =>
                  await const MethodChannel('PIAPIRI_CHANNEL').invokeMethod('marketRedirect'),
            );
          }

          await getIt<NotificationHandler>().executePendingNavigationIfExists();
        } else {
          PBottomSheet.showError(
            NavigatorKeys.navigatorKey.currentContext!,
            content: L10n.tr('healthMessage'),
          );
        }
      } else {
        Utils().showConnectivityAlert(
          context: NavigatorKeys.navigatorKey.currentContext!,
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          type: PageState.failed,
        ),
      );
      event.onError(e.toString());
    }
  }

  FutureOr<void> _onSetDeviceId(
    SetDeviceIdEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        deviceId: event.deviceId,
      ),
    );
  }

  FutureOr<void> _onSetAppTheme(
    SetAppThemeEvent event,
    Emitter<AppInfoState> emit,
  ) {
    emit(
      state.copyWith(
        appTheme: event.appTheme,
      ),
    );
  }

  FutureOr<void> _onGetUSClockEvent(
    GetUSClockEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse usTimeResponse = await _appInfoRepository.getUSClock();

    if (usTimeResponse.success) {
      USTimeModel usTime = USTimeModel.fromJson(usTimeResponse.data);
      emit(
        state.copyWith(
          type: PageState.success,
          usTime: usTime,
        ),
      );
      event.onSuccessCallback?.call();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: usTimeResponse.error?.message ?? '',
            errorCode: '99USCL01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetUpdatedRecords(
    GetUpdatedRecords event,
    Emitter<AppInfoState> emit,
  ) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    String? lastUpdatedDate = getIt<LocalStorage>().read(LocalKeys.lastUpdateDate);

    String latestUpdateDate = lastUpdatedDate != null
        ? DateTime.parse(
            lastUpdatedDate,
          ).formatToJsonWithHours()
        : '2025-07-25 12:30';
    talker.critical(latestUpdateDate);

    ApiResponse response = await _appInfoRepository.getUpdatedRecords(
      lastDate: latestUpdateDate,
    );

    if (response.success) {
      dbHelper.updateRecords(response.data).then((_) => event.callback());
      getIt<LocalStorage>().write(LocalKeys.lastUpdateDate, DateTime.now().toString());
    }
  }

  FutureOr<void> _onErrorAlertEvent(
    ErrorAlertEvent event,
    Emitter<AppInfoState> emit,
  ) {
    if (!state.hasErrorAlert) {
      event.callback?.call();
    }
    emit(
      state.copyWith(
        hasErrorAlert: event.status,
      ),
    );
  }

  FutureOr<void> _onSetMaxInstrumentCount(
    SetMaxInstrumentCount event,
    Emitter<AppInfoState> emit,
  ) {
    emit(
      state.copyWith(
        maxInstrumentCount: event.maxInstrumentCount,
        maxGridCount: event.maxGridCount,
      ),
    );
  }

  FutureOr<void> _onInvalidateCache(
    InvalidateCacheEvent event,
    Emitter<AppInfoState> emit,
  ) {
    DateTime now = DateTime.now();
    DateTime lastMidnight = DateTime(now.year, now.month, now.day);
    String? lastUpdatedDate = getIt<LocalStorage>().read(LocalKeys.lastUpdateDate);
    if (lastUpdatedDate != null && lastMidnight.isAfter(DateTime.parse(lastUpdatedDate))) {
      DefaultCacheManager().emptyCache();
    }
  }

  FutureOr<void> _onGetCautionList(
    GetCautionListEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    File precautionFile = await _appInfoRepository.getPrecautionList();
    List<PrecautionModel> precautionList = [];
    try {
      await precautionFile.readAsLines().then((lines) {
        for (int i = 2; i < lines.length; i++) {
          List<String> elements = lines[i].split(';');
          if (elements.length >= 6) {
            precautionList.add(
              PrecautionModel(
                elements[0],
                elements[1],
                elements[2],
                elements[3],
                elements[4],
                elements[5],
              ),
            );
          }
        }
        emit(
          state.copyWith(
            precautionList: precautionList,
          ),
        );
      });
    } catch (e) {
      LogUtils.pLog(e.toString());
    }
  }

  FutureOr<void> _onChangeEnv(
    ChangeEnv event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        customerId: '',
        customerSettings: AppSettings(),
      ),
    );
    getIt<LocalStorage>().delete(LocalKeys.customerInfo);
    getIt<LocalStorage>().delete(LocalKeys.otpTimeOut);
    getIt<LocalStorage>().delete(LocalKeys.customerType);
    getIt<TokenService>().clearToken();
    ServiceLocatorManager.cancelQueue();
    SessionTimer.instance?.cancelTimer();
    event.callback();
  }

  FutureOr<void> _onWriteHasMembership(
    WriteHasMembershipEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    _appInfoRepository.writeHasMembership(
      status: event.status,
      gsm: event.gsm,
    );
  }

  FutureOr<void> _onReadHasMembership(
    ReadHasMembershipEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    state.copyWith(
      type: PageState.loading,
    );
    await event.callback(_appInfoRepository.readHasMembership());
    emit(
      state.copyWith(
        type: PageState.success,
        hasMembership: _appInfoRepository.readHasMembership(),
      ),
    );
  }

  FutureOr<void> _onReadLoginCount(
    ReadLoginCountEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    state.copyWith(
      type: PageState.loading,
    );
    await event.callback(_appInfoRepository.readLoginCount());
    emit(
      state.copyWith(
        type: PageState.success,
        loginCount: _appInfoRepository.readLoginCount(),
      ),
    );
  }

  FutureOr<void> _onReadShowCreateAccount(
    ReadShowAccountEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    state.copyWith(
      type: PageState.loading,
    );
    event.callback(
      _appInfoRepository.readShowCreateAccount(),
    );
    emit(
      state.copyWith(
        type: PageState.success,
        showCreateAccount: _appInfoRepository.readShowCreateAccount(),
      ),
    );
  }

  FutureOr<void> _onChangeSelectedMarketMenu(
    ChangeSelectedMarketMenuEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedMarketMenuIndex: event.selectedIndex,
      ),
    );
  }

  FutureOr<void> _onGetSessionHours(
    GetSessionHoursEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    ApiResponse response = await _appInfoRepository.getSessionHours();
    Map<String, dynamic> data = response.data;
    SessionModel bistPPSession = SessionModel(
      marketCode: 'BISTPP',
      openHour: data['BISTPP'][0],
      closeHour: data['BISTPP'][1],
    );

    List<SessionModel> bistViopSession = [];
    for (String key in data.keys.where((element) => element.startsWith('BISTVIOP'))) {
      bistViopSession.add(
        SessionModel(
          marketCode: key.split('/').last,
          openHour: data[key][0],
          closeHour: data[key][1],
        ),
      );
    }

    emit(state.copyWith(
      bistPPSession: bistPPSession,
      bistViopSession: bistViopSession,
    ));
  }
}
