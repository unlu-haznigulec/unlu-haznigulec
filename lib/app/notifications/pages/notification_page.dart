import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:auto_route/auto_route.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/app/notifications/widget/notification_item.dart';
import 'package:piapiri_v2/app/notifications/widget/unread_count_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/notification_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _selectedNotificationCategoryTitle = '';
  int _selectedNotificationCategoryId = 0;
  ScrollController? _scrollController;
  // ------------------- New Part ------------------- //
  late NotificationsBloc _bloc;
  late AuthBloc _authBloc;
  late PagingController _pagingController;

  @override
  void initState() {
    _bloc = getIt<NotificationsBloc>();
    _authBloc = getIt<AuthBloc>();
    _scrollController = ScrollController();

    if (_authBloc.state.isLoggedIn) {
      _bloc.add(
        NotificationGetCategories(
          callback: (NotificationCategoryModel selectedCategory) {
            setState(() {
              _selectedNotificationCategoryTitle = selectedCategory.title;
              _selectedNotificationCategoryId = selectedCategory.categoryId;
            });
          },
        ),
      );
    }

    _pagingController = PagingController<int, Widget>(firstPageKey: 0)
      ..addPageRequestListener((int page) {
        _bloc.add(
          NotificationGetNotifications(
            categoryId: _selectedNotificationCategoryId,
            pageKey: page,
          ),
        );
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _readCount(0);
    super.dispose();
  }

  void _appendNotifications(
    List<NotificationModel> notifications,
    int page,
  ) {
    /// Bildirimleri listelerken pagination mantığı uygulandıgı, bildirimleri 20 şer 20 şer yüklemek için ayarlanan yer.
    final List<Widget> notificationList = _prepareNotifications(notifications);
    final isLastPage = notificationList.length < 20;
    if (isLastPage) {
      _pagingController.appendLastPage(notificationList);
    } else {
      _pagingController.appendPage(notificationList, page + 1);
    }
  }

  List<Widget> _prepareNotifications(List<NotificationModel> notifications) {
    return notifications
        .map<NotificationItem>(
          (e) => NotificationItem(
            notification: e,
            categoryId: _selectedNotificationCategoryId,
            deletedNotification: (notificationId) {
              _bloc.add(
                NotificationDeleteEvent(
                  notificationId: notificationId,
                  callback: () {
                    /// bildirimi silme işinden sonra, sildiğimiz bildirimi listeden kaldırıyoruz
                    notifications.remove(e);
                    _pagingController.itemList = _prepareNotifications(notifications);

                    /// silme işleminden sonra bildirimler tekrar çekiliyor
                    _readCount(_selectedNotificationCategoryId);
                  },
                ),
              );
            },
            makeAsRead: () => _readCount(_selectedNotificationCategoryId),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, appInfoState) {
        return PBlocConsumer<NotificationsBloc, NotificationsState>(
          bloc: _bloc,
          listenWhen: (previous, current) => previous.type == PageState.fetching && current.type == PageState.success,
          listener: (context, state) {
            _appendNotifications(
              state.newlyFetchedNotifications,
              state.pageNumber,
            );
          },
          builder: (context, state) {
            return Scaffold(
              appBar: PInnerAppBar(
                title: L10n.tr('bildirim_merkezi'),
                actions: [
                  if (appInfoState.isLoggedIn)
                    InkWell(
                      onTap: () {
                        router.push(
                          const NotificationSettingsRoute(),
                        );
                      },
                      child: SvgPicture.asset(
                        ImagesPath.setting,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                ],
              ),
              body: SafeArea(
                child: !appInfoState.isLoggedIn
                    ? SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: CreateAccountWidget(
                          memberMessage: L10n.tr('create_account_notification'),
                          loginMessage: L10n.tr('login_notification_alert'),
                          onLogin: () => router.push(
                            AuthRoute(
                              afterLoginAction: () async {
                                router.push(
                                  const NotificationRoute(),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height,
                        padding: const EdgeInsets.only(
                          left: Grid.m,
                          top: Grid.m,
                          right: Grid.m,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.notificationCategories.isNotEmpty)
                              _categoryWidgets(
                                state.notificationCategories,
                                state,
                              ),
                            Expanded(
                              child: PagedListView(
                                pagingController: _pagingController,
                                builderDelegate: PagedChildBuilderDelegate<Widget>(
                                  itemBuilder: (_, dynamic item, __) {
                                    return item as Widget;
                                  },
                                  noItemsFoundIndicatorBuilder: (context) => NoDataWidget(
                                    iconName: ImagesPath.notificationOff,
                                    message: L10n.tr('no_pending_notification'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _categoryWidgets(
    List<NotificationCategoryModel> categories,
    NotificationsState state,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Grid.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PCustomOutlinedButtonWithIcon(
            text: L10n.tr(
                _selectedNotificationCategoryTitle == 'all' ? 'all_notifications' : _selectedNotificationCategoryTitle),
            iconSource: ImagesPath.chevron_down,
            onPressed: () {
              PBottomSheet.show(
                context,
                title: L10n.tr('notifications'),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const PDivider(),
                  itemBuilder: (context, index) {
                    final NotificationCategoryModel category = categories[index];

                    return BottomsheetSelectTile(
                      title: L10n.tr(
                        category.key == 'all' ? 'all_notifications' : category.key,
                      ),
                      isSelected: category.categoryId == _selectedNotificationCategoryId,
                      value: category,
                      onTap: (title, value) {
                        NotificationCategoryModel category = value;

                        setState(() {
                          _selectedNotificationCategoryId = category.categoryId;
                          _selectedNotificationCategoryTitle = category.title;
                          _bloc.add(
                            NotificationSetCountByCategory(
                              categoryId: _selectedNotificationCategoryId,
                            ),
                          );

                          router.maybePop();
                        });

                        _pagingController.refresh();
                      },
                    );
                  },
                ),
              );
            },
          ),
          if (state.notifications.isNotEmpty) ...[
            const SizedBox(
              width: Grid.xs,
            ),
            Row(
              children: [
                PBlocBuilder<NotificationsBloc, NotificationsState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      return UnReadCountWidget(
                        /// Kategorilere göre okunmamış bildirim sayısı
                        unReadCount: state.notificationUnReadCount ?? 0,
                      );
                    }),
                const SizedBox(
                  width: Grid.s + Grid.xs,
                ),
                InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SvgPicture.asset(
                                ImagesPath.notification,
                                width: 40,
                                height: 40,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: context.pColorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Grid.m,
                            ),
                            child: Text(
                              L10n.tr(
                                'un_read_notification_message',
                                args: [
                                  '${state.notificationUnReadCount ?? 0}',
                                ],
                              ),
                            ),
                          ),
                          POutlinedButton(
                            text: L10n.tr('clear_all_notifications'),
                            fillParentWidth: true,
                            onPressed: () => _deleteAll(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Grid.s + Grid.xs,
                            ),
                            child: PButton(
                              text: L10n.tr('tumunu_okundu_olarak_isaretle'),
                              fillParentWidth: true,
                              onPressed: () => _markAllAsRead(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    ImagesPath.brush,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  _markAllAsRead() async {
    /// Tümünü okundu olarak işaretlemek için kullanılan event.
    _bloc.add(
      NotificationReadEvent(
        categoryId: _selectedNotificationCategoryId,
        notificationId: const [0],
        callback: () async {
          AppBadgePlus.updateBadge(0);

          /// Uygulamanın üzerinde badge numarasını sıfırlar.
          _readCount(_selectedNotificationCategoryId);
          _pagingController.refresh();
        },
        isRead: true,
      ),
    );

    router.maybePop();
  }

  _deleteAll() async {
    _bloc.add(
      NotificationDeleteEvent(
        categoryId: _selectedNotificationCategoryId,
        notificationId: const [0],
        callback: () async {
          AppBadgePlus.updateBadge(0);
          _readCount(_selectedNotificationCategoryId);
          _pagingController.itemList?.clear();
          setState(() {});
        },
      ),
    );

    router.maybePop();
  }

  _readCount(int categoryId) {
    if (getIt<AuthBloc>().state.isLoggedIn) {
      _bloc.add(
        NotificationGetCategories(),
      );
    }
  }
}
