import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/rich_text.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreateAccountInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final bool? showLoginText;
  final Function() onLogin;
  const CreateAccountInfoCard({
    super.key,
    required this.title,
    required this.description,
    this.showLoginText = false,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.tr(title),
          style: context.pAppStyle.labelMed18textPrimary,
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Text(
          L10n.tr(description),
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        const SizedBox(
          height: Grid.s + Grid.xxs,
        ),
        PButtonWithIcon(
          text: L10n.tr(getIt<AppInfoBloc>().state.loginCount.isEmpty ? 'hesap_ac' : 'giris_yap'),
          sizeType: PButtonSize.small,
          iconAlignment: IconAlignment.start,
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
                  getIt<Analytics>().track(AnalyticsEvents.splashRegisterCallClick);
                  await const MethodChannel('PIAPIRI_CHANNEL').invokeMethod('initEnqura');
                }
              : onLogin,
        ),
        if (showLoginText! && getIt<AppInfoBloc>().state.loginCount.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: Grid.m,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GeneralRichText(
                  textSpan1: L10n.tr('account_already_exist_question'),
                  textSpan2: L10n.tr('splash_login'),
                  textStyle: context.pAppStyle.labelReg14textPrimary),
            ),
          ),
        ],
      ],
    );
  }
}
