import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_state.dart';
import 'package:piapiri_v2/app/app_settings/repository/settings_repository.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/session_timer.dart';
import 'package:piapiri_v2/core/model/general_settings.dart';
import 'package:piapiri_v2/core/model/language_enum.dart';
import 'package:piapiri_v2/core/model/order_settings.dart';
import 'package:piapiri_v2/core/model/theme_enum.dart';
import 'package:piapiri_v2/core/model/timeout_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AppSettingsBloc extends PBloc<AppSettingsState> {
  final SettingsRepository _settingsRepository;

  AppSettingsBloc({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(initialState: AppSettingsState()) {
    on<GetApplicationDeviceSettings>(_onGetApplicationDeviceSettings);
    on<GetApplicationCustomerSettings>(_onGetApplicationCustomerSettings);
    on<GetOrderSettingsEvent>(_onGetOrderSettings);
    on<GetLocalGeneralSettingsEvent>(_onGetLocalGeneralSettings);
    on<SetGeneralSettingsEvent>(_onSetGeneralSettings);
    on<SetOrderSettingsEvent>(_onSetOrderSettings);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ResetApplicationSettingsEvent>(_onResetApplicationSettings);
    on<GetCustomerParametersEvent>(_onGetCustomerParameters);
    on<UpdateCustomerParametersEvent>(_onUpdateCustomerParameters);
  }

  FutureOr<void> _onGetApplicationDeviceSettings(
    GetApplicationDeviceSettings event,
    Emitter<AppSettingsState> emit,
  ) async {
    ApiResponse response = await _settingsRepository.getDeviceSettings(deviceId: event.deviceId);
    if (response.success &&
        response.data['settings'] != null &&
        (response.data['settings'] as List<dynamic>).isNotEmpty) {
      _setLocalGeneralSettings(response.data['settings']);
      //local ayarları cihaza uygular
      add(GetLocalGeneralSettingsEvent());
    } else {
      _settingsRepository.setApplicationSettings(generalSettings: const GeneralSettings());
    }
  }

  FutureOr<void> _onGetApplicationCustomerSettings(
    GetApplicationCustomerSettings event,
    Emitter<AppSettingsState> emit,
  ) async {
    String? customerId = getIt<LocalStorage>().read(LocalKeys.customerIdForLocalSettings);
    if (customerId != UserModel.instance.customerId) {
      if (customerId != null) {
        getIt<LocalStorage>().delete(LocalKeys.customerIdForLocalSettings);
      }
      getIt<LocalStorage>().write(LocalKeys.customerIdForLocalSettings, UserModel.instance.customerId);
      ApiResponse response = await _settingsRepository.getCustomerSettings();
      if (response.success &&
          response.data['settings'] != null &&
          (response.data['settings'] as List<dynamic>).isNotEmpty) {
        final Completer<void> settingKeysCompleter = Completer<void>();
        _setLocalGeneralSettings(response.data['settings']);
        //local ayarları cihaza uygular
        add(GetLocalGeneralSettingsEvent(
          onCompleter: () => settingKeysCompleter.complete(),
        ));
        await settingKeysCompleter.future;
      }
    }
    event.callback?.call();
  }

  FutureOr<void> _onGetOrderSettings(
    GetOrderSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    ApiResponse response = await _settingsRepository.getOrderSettings();

    if (response.success) {
      OrderSettings orderSettings;
      try {
        orderSettings = OrderSettings.fromJson(json.decode(response.data['settings']));
      } catch (e) {
        orderSettings = OrderSettings();
      }

      // Yeni olusturulan kullaniclar icin default account 100 olarak tanimlanir.
      // kullanici hesaplarinda backendden gelen default account yok ise loginden gelen default account tanimlanir
      List<String> accountList = UserModel.instance.accounts.map((e) => e.accountId.split('-').last).toList();

      bool? updateEquityDefaultAccount = !accountList.contains(orderSettings.equityDefaultAccount);
      bool? updateViopDefaultAccount = !accountList.contains(orderSettings.viopDefaultAccount);
      bool? updateFundDefaultAccount = !accountList.contains(orderSettings.fundDefaultAccount);
      if (updateEquityDefaultAccount || updateViopDefaultAccount || updateFundDefaultAccount) {
        String? defaultAccount = _settingsRepository.getDefaultAccount().split('-').last;
        if (defaultAccount.isEmpty) {
          defaultAccount = accountList.first;
        }
        add(SetOrderSettingsEvent(
          equityDefaultAccount: updateEquityDefaultAccount ? defaultAccount : null,
          viopDefaultAccount: updateViopDefaultAccount ? defaultAccount : null,
          fundDefaultAccount: updateFundDefaultAccount ? defaultAccount : null,
        ));
      }

      emit(
        state.copyWith(
          type: PageState.success,
          orderSettings: orderSettings,
        ),
      );
    }
    event.onCallback();
  }

  FutureOr<void> _onGetLocalGeneralSettings(
    GetLocalGeneralSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    GeneralSettings generalSettings = _settingsRepository.getApplicationSettings() ?? const GeneralSettings();

    getIt<LanguageBloc>().add(LanguageSetEvent(languageCode: generalSettings.language.value));
    event.onSuccess?.call(generalSettings);
    emit(
      state.copyWith(
        type: PageState.success,
        generalSettings: generalSettings,
      ),
    );
    event.onCompleter?.call();
  }

  FutureOr<void> _onSetGeneralSettings(
    SetGeneralSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.success,
        generalSettings: state.generalSettings.copyWith(
          theme: event.theme,
          language: event.language,
          timeout: event.timeout,
          keepScreenOpen: event.keepScreenOpen,
          touchFaceId: event.touchFaceId,
          showCases: event.showCase,
        ),
      ),
    );
    if (event.language != null) {
      getIt<LanguageBloc>().add(LanguageSetEvent(languageCode: event.language!.value));
    }
    if (event.timeout != null) {
      SessionTimer.instance?.cancelTimer();
      SessionTimer(sessionTimeout: event.timeout!.value);
      SessionTimer.instance?.startTimer();
    }

    _settingsRepository.setApplicationSettings(generalSettings: state.generalSettings);
  }

  FutureOr<void> _onSetOrderSettings(
    SetOrderSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        orderSettings: state.orderSettings.copyWith(
          equityDefaultAccount: event.equityDefaultAccount,
          viopDefaultAccount: event.viopDefaultAccount,
          fundDefaultAccount: event.fundDefaultAccount,
          equityDefaultOrderType: event.equityDefaultOrderType,
          viopDefaultOrderType: event.viopDefaultOrderType,
          usDefaultOrderType: event.usDefaultOrderType,
          equityDefaultValidity: event.equityDefaultValidity,
          viopDefaultValidity: event.viopDefaultValidity,
          depthCount: event.depthCount,
          depthType: event.depthType,
          earningInterest: event.earningInterest,
          transactionApprovalRequest: event.transactionApprovalRequest,
          orderCompletion: event.orderCompletion,
          statementPreference: event.statementPreference,
        ),
      ),
    );

    ApiResponse response = await _settingsRepository.setOrderSettings(
      orderSettings: state.orderSettings,
    );
    if (response.success) {
      event.onSuccess?.call(response.dioResponse?.statusMessage ?? '', true);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(response.error?.message ?? ''),
            errorCode: '05PROF30',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _settingsRepository.changePassword(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );

    if (response.success) {
      event.onSuccess?.call(
        'password_changed_success',
        true,
      );
      getIt<LocalStorage>().write(
        LocalKeys.showBiometricLogin,
        false,
      );
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(response.error?.message ?? ''),
            errorCode: '05PROF30',
          ),
        ),
      );
      event.onSuccess?.call(
        response.error?.message ?? '',
        false,
      );
    }
  }

  FutureOr<void> _onResetApplicationSettings(
    ResetApplicationSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _settingsRepository.resetApplicationSettings();
    if (response.success) {
      if (getIt<AuthBloc>().state.isLoggedIn) {
        getIt<AuthBloc>().add(const LogoutEvent());
      } else {
        //getIt<AppInfoBloc>().add(AppInfoGetAppSettingsByDeviceIdEvent());
      }

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF04',
          ),
        ),
      );
    }
  }

//nemalandırma
  FutureOr<void> _onGetCustomerParameters(
    GetCustomerParametersEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    ApiResponse response = await _settingsRepository.getCustomerParameters();
    if (response.success) {
      emit(
        state.copyWith(
          orderSettings: state.orderSettings.copyWith(
            earningInterest: response.data['interest'],
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUpdateCustomerParameters(
    UpdateCustomerParametersEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    ApiResponse response = await _settingsRepository.updateCustomerParemeters(
      receiptType: event.receiptType,
      interest: event.interest,
    );

    if (response.success) {
      event.onSuccess?.call();
    } else {
      event.onFailed?.call(L10n.tr('${response.error?.message}'));
    }
  }

  _setLocalGeneralSettings(List<dynamic> settings) {
    try {
      final themeSetting = settings.firstWhere(
        (setting) => setting['key'] == 'theme',
        orElse: () => null,
      );
      int themeValue = themeSetting?['value'] == null ? 1 : int.tryParse(themeSetting['value']) ?? 1;
      ThemeEnum theme = themeValue == 1 ? ThemeEnum.light : ThemeEnum.dark;

      final languageSetting = settings.firstWhere(
        (setting) => setting['key'] == 'language',
        orElse: () => null,
      );
      int languageValue = languageSetting?['value'] == null ? 1 : int.tryParse(languageSetting['value']) ?? 1;
      LanguageEnum language = languageValue == 1 ? LanguageEnum.turkish : LanguageEnum.english;

      final timeoutSetting = settings.firstWhere(
        (setting) => setting['key'] == 'timeout',
        orElse: () => null,
      );
      int timeoutSettingValue = timeoutSetting?['value'] == null ? 0 : int.tryParse(timeoutSetting['value']) ?? 0;
      TimeoutEnum timeOut = TimeoutEnum.values.firstWhere(
        (e) => e.value == timeoutSettingValue,
        orElse: () => TimeoutEnum.fourH,
      );

      final keepScreenOnSetting = settings.firstWhere(
        (setting) => setting['key'] == 'keep_screen_on',
        orElse: () => null,
      );
      int keepScreenValue = keepScreenOnSetting?['value'] == null ? 0 : int.tryParse(keepScreenOnSetting['value']) ?? 0;
      bool keepScreenOpen = keepScreenValue == 0 ? false : true;

      // final touchFaceIdSetting = settings.firstWhere(
      //   (setting) => setting['key'] == 'activate_touchid',
      //   orElse: () => null,
      // );
      // int touchFaceIdValue = touchFaceIdSetting?['value'] == null ? 0 : int.tryParse(touchFaceIdSetting['value']) ?? 0;
      // bool touchFaceId = touchFaceIdValue == 0 ? false : true;

      //local ayarları kaydeder
      _settingsRepository.setApplicationSettings(
        generalSettings: GeneralSettings(
          theme: theme,
          language: language,
          timeout: timeOut,
          keepScreenOpen: keepScreenOpen,
          touchFaceId: _settingsRepository.getV1BiometricData() ?? false,
        ),
      );
    } catch (e) {
      //local ayarları kaydeder
      _settingsRepository.setApplicationSettings(
        generalSettings: GeneralSettings(
          touchFaceId: _settingsRepository.getV1BiometricData() ?? false,
        ),
      );
    }
  }
}
