import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreateAccountWidget extends StatelessWidget {
  final String loginMessage;
  final String memberMessage;
  final Function()? onLogin;
  const CreateAccountWidget({
    super.key,
    required this.loginMessage,
    required this.memberMessage,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Grid.m,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImagesPath.userSec,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            Text(
              getIt<AppInfoBloc>().state.loginCount.isEmpty ? memberMessage : loginMessage,
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelReg16textPrimary,
            ),
            const SizedBox(
              height: Grid.m,
            ),
            PButtonWithIcon(
              text: L10n.tr(getIt<AppInfoBloc>().state.loginCount.isEmpty ? 'hesap_ac' : 'giris_yap'),
              sizeType: PButtonSize.small,
              icon: SvgPicture.asset(
                ImagesPath.arrow_up_right,
                width: 17,
                height: 17,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.lightHigh,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: getIt<AppInfoBloc>().state.loginCount.isEmpty
                  ? () async {
                      getIt<Analytics>().track(
                        AnalyticsEvents.videoCallSignUpClick,
                        taxonomy: [
                          InsiderEventEnum.createAccountPage.value,
                        ],
                      );
                      await const MethodChannel('PIAPIRI_CHANNEL').invokeMethod('initEnqura');
                    }
                  : onLogin,
            ),
          ],
        ),
      ),
    );
  }
}
