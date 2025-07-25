import 'package:design_system/foundations/spacing/grid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class LocalNotification extends StatelessWidget {
  final RemoteMessage remoteMessage;
  final VoidCallback onClose;
  const LocalNotification({
    super.key,
    required this.remoteMessage,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pColorScheme.transparent,
      child: InkWell(
        onTap: getIt<AuthBloc>().state.isLoggedIn
            ? () => router.push(
                  const NotificationRoute(),
                )
            : null,
        child: Padding(
          padding: EdgeInsets.only(
            left: Grid.s,
            right: Grid.s,
            top: MediaQuery.of(context).padding.top + Grid.s,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: Grid.l,
              horizontal: Grid.m,
            ),
            decoration: BoxDecoration(
              color: context.pColorScheme.card,
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  Grid.m,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.pColorScheme.primary.shade300,
                  offset: const Offset(0, 4), // Gölgeyi aşağı kaydır
                  blurRadius: 6, // Bulanıklık
                  spreadRadius: -3, // Üstte gölge olmaması için negatif değer
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: onClose,
                    child: SvgPicture.asset(
                      ImagesPath.x,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Text(
                  remoteMessage.notification!.title ?? '',
                  style: context.pAppStyle.labelMed14primary,
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                Text(
                  remoteMessage.notification!.body ?? '',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: context.pAppStyle.labelReg12textPrimary,
                ),
                const SizedBox(
                  height: Grid.m,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
