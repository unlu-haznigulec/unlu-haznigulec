import 'dart:convert';

import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/order_settings.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class SettingsService {
  final ApiClient api;

  SettingsService(this.api);

  static const String _getApplicationSettingsByDeviceId = '/usersettings/getapplicationsettingsbydeviceid';
  static const String _getApplicationSettingsByCustomerId = '/usersettings/getapplicationsettingsbycustomerextid';
  static const String _getOrderSettings = '/UserSettings/getusersettings';
  static const String _setOrderSettings = '/UserSettings/setusersettings';

  Future<ApiResponse> getDeviceSettings({
    required deviceId,
  }) async {
    Map<String, dynamic> data = {
      'deviceId': deviceId,
    };
    try {
      return await api.post(
        _getApplicationSettingsByDeviceId,
        tokenized: false,
        body: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> getCustomerSettings() async {
    Map<String, dynamic> data = {
      'customerExtId': UserModel.instance.customerId ?? '',
    };
    try {
      return await api.post(
        _getApplicationSettingsByCustomerId,
        tokenized: true,
        body: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> getOrderSettings() async {
    Map<String, dynamic> data = {'customerExtId': UserModel.instance.customerId};
    try {
      return await api.post(
        _getOrderSettings,
        tokenized: true,
        body: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> setOrderSettings(OrderSettings orderSettings) async {
    Map<String, dynamic> data = {
      'customerExtId': UserModel.instance.customerId,
      'settings': json.encode(orderSettings.toJson()),
    };
    try {
      return await api.post(
        _setOrderSettings,
        tokenized: true,
        body: data,
      );
    } catch (e) {
      rethrow;
    }
  }
}
