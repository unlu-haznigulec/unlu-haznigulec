import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NoCurrencyAccountWarningWidget extends StatelessWidget {
  final String? text;
  const NoCurrencyAccountWarningWidget({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          SvgPicture.asset(
            ImagesPath.alertCircle,
            width: 52,
            height: 52,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            text ??
                L10n.tr(
                  'no_usd_account_desc',
                  args: ['USD'],
                ),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelReg16textPrimary,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: Grid.l,
              bottom: Grid.m,
            ),
            child: Row(
              children: [
                Expanded(
                  child: POutlinedButton(
                    text: L10n.tr('vazgeç'),
                    variant: PButtonVariant.error,
                    onPressed: () {
                      router.maybePop();
                    },
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  child: PButtonWithIcon(
                    text: L10n.tr('ara'),
                    height: 52,
                    iconAlignment: IconAlignment.end,
                    icon: SvgPicture.asset(
                      ImagesPath.arrow_up_right,
                      width: 17,
                      height: 17,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.lightHigh,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => _call('4447333'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _call(String phone) async {
    router.maybePop();

    Uri url = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(url)) {
      launchUrl(url);
    }
  }
}
