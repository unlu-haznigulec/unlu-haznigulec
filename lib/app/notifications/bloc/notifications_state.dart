import 'package:piapiri_v2/app/notifications/model/notification_preferences_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';

class NotificationsState extends PState {
  final int? notificationUnReadCount;
  final NotificationDetail? notificationDetailModel;
  final List<NotificationCategoryModel> notificationCategories;
  final NotificationCategoryModel? selectedCategory;
  final int pageNumber;
  final List<NotificationModel> notifications;
  final List<NotificationModel> newlyFetchedNotifications;
  final List<NotificationPreferencesModel> notificationPreferences;

  const NotificationsState({
    super.type = PageState.initial,
    super.error,
    this.notificationUnReadCount,
    this.notificationDetailModel,
    this.notifications = const [],
    this.selectedCategory,
    this.pageNumber = 0,
    this.notificationCategories = const [],
    this.newlyFetchedNotifications = const [],
    this.notificationPreferences = const [],
  });

  @override
  NotificationsState copyWith({
    PageState? type,
    PBlocError? error,
    int? notificationUnReadCount,
    NotificationDetail? notificationDetailModel,
    List<NotificationCategoryModel>? notificationCategories,
    NotificationCategoryModel? selectedCategory,
    int? pageNumber,
    List<NotificationModel>? notifications,
    List<NotificationModel>? newlyFetchedNotifications,
    List<NotificationPreferencesModel>? notificationPreferences,
  }) {
    return NotificationsState(
      type: type ?? this.type,
      error: error ?? this.error,
      notificationUnReadCount: notificationUnReadCount ?? this.notificationUnReadCount,
      notificationDetailModel: notificationDetailModel ?? this.notificationDetailModel,
      notificationCategories: notificationCategories ?? this.notificationCategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      pageNumber: pageNumber ?? this.pageNumber,
      notifications: notifications ?? this.notifications,
      newlyFetchedNotifications: newlyFetchedNotifications ?? this.newlyFetchedNotifications,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        notificationUnReadCount,
        notificationDetailModel,
        notificationCategories,
        selectedCategory,
        pageNumber,
        notifications,
        newlyFetchedNotifications,
        notificationPreferences
      ];
}
