import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/local_notification.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum NotificationState { onMessage, onLaunch, onResume }

class NotificationHandlerImpl extends NotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late NotificationState state;

  List<NotificationDetail> notificationsList = <NotificationDetail>[];
  bool hasActiveNotification = false;

  @override
  Future<void> executePendingNavigationIfExists() async {
    final RemoteMessage? initialNotification = await _firebaseMessaging.getInitialMessage();

    if (initialNotification != null) {
      state = NotificationState.onLaunch;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.push(const NotificationRoute());
      });
    }
  }

  @override
  void performNotificationAction({
    String? action,
    String? params,
    String? tags,
    String? externalLink,
    String? fileUrl,
    NotificationModel? notificationModel,
  }) {
    switch (action) {
      case 'SimpleNotification':
        if (notificationModel != null) {
          router.push(
            NotificationDetailRoute(
              selectedNotification: notificationModel,
            ),
          );
        } else {
          router.push(
            const NotificationRoute(),
          );
        }

        break;
      case 'ExternalLink':
        if (externalLink != null) {
          router.push(
            NotificationDetailWebViewRoute(
              url: externalLink,
            ),
          );
        } else {
          router.push(
            const NotificationRoute(),
          );
        }
        break;
      case 'InternalNavigation': // Öneriler
        if (params == 'buysell') {
          getIt<AuthBloc>().state.isLoggedIn
              ? router.push(
                  CreateOrderRoute(
                    symbol: MarketListModel(
                      symbolCode: tags.toString().split(',')[0],
                      updateDate: '',
                    ),
                    action: OrderActionTypeEnum.buy,
                  ),
                )
              : router.push(
                  AuthRoute(
                    afterLoginAction: () {
                      router.push(
                        CreateOrderRoute(
                          symbol: MarketListModel(
                            symbolCode: tags.toString().split(',')[0],
                            updateDate: '',
                          ),
                          action: OrderActionTypeEnum.buy,
                        ),
                      );
                    },
                  ),
                );
        }
        if (params == 'report_details') {
          router.popUntilRoot();
          getIt.get<TabBloc>().add(
                const TabChangedEvent(
                  tabIndex: 2,
                  marketMenu: MarketMenu.istanbulStockExchange,
                  marketMenuTabIndex: 3,
                ),
              );
        }
        if (params == 'analysis_robo_signals') {
          router.popUntilRoot();
          getIt.get<TabBloc>().add(
                const TabChangedEvent(
                  tabIndex: 2,
                  marketMenu: MarketMenu.istanbulStockExchange,
                  marketMenuTabIndex: 3,
                ),
              );
        }
        break;
      case 'ShowFile':
        if (fileUrl != null) {
          router.push(
            NotificationDetailPdfRoute(
              pdfUrl: fileUrl,
            ),
          );
        } else {
          router.push(
            const NotificationRoute(),
          );
        }
        break;
      default:
        LogUtils.pLog('any notification');
        break;
    }
  }

  @override
  Future<void> registerForNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (PlatformUtils.isIos) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          await _register();
        } else {
          await Future<void>.delayed(
            const Duration(
              seconds: 3,
            ),
          );
          apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken != null) {
            await _register();
          }
        }
      } else {
        await _register();
      }
    } else {
      // ignore: avoid_print
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _register() async {
    _firebaseMessaging.getToken().then((String? token) async {
      if (token == null) {
        return;
      }
      getIt<LocalStorage>().write(LocalKeys.fcmToken, token);
      await getIt<PPApi>().notificationService.updateRegistrationToken(
            token: token,
            deviceId: getIt<AppInfo>().deviceId,
          );
      talker.critical('token: $token');
    });
    _listenNotifications();
  }

  void _listenNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      state = NotificationState.onMessage;
      if (remoteMessage.notification != null) {
        showOverlayNotification(
          (context) => LocalNotification(
            remoteMessage: remoteMessage,
            onClose: () => OverlaySupportEntry.of(context)?.dismiss(),
          ),
          duration: const Duration(
            seconds: 4,
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) async {
      state = NotificationState.onResume;
      LogUtils.pLog(remoteMessage.data.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.push(const NotificationRoute());
      });
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      talker.log(
        message.notification.toString(),
        logLevel: LogLevel.warning,
      );
    });
  }
}
