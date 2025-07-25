import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContractsTextfieldWidget extends StatelessWidget {
  final String? value;
  final String keys;
  final bool? isEnabled;
  final bool? isShowSuffixIcon;
  final TextEditingController? controller;
  const ContractsTextfieldWidget({
    super.key,
    this.value,
    required this.keys,
    this.isEnabled,
    this.isShowSuffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          L10n.tr(keys),
          textAlign: TextAlign.start,
          style: context.pAppStyle.labelMed12textSecondary,
          maxLines: 2,
        ),
        TextField(
          minLines: 1,
          maxLines: 10,
          controller: controller ?? TextEditingController(text: value),
          enabled: isEnabled ?? false,
          cursorColor: context.pColorScheme.primary,
          textInputAction: TextInputAction.done,
          style: context.pAppStyle.labelMed16primary.copyWith(
            color: value == L10n.tr('choose') ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
          ),
          decoration: InputDecoration(
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: value == L10n.tr('choose') ? context.pColorScheme.primary : context.pColorScheme.textQuaternary,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: value == L10n.tr('choose') ? context.pColorScheme.primary : context.pColorScheme.textQuaternary,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: value == L10n.tr('choose') ? context.pColorScheme.primary : context.pColorScheme.textQuaternary,
              ),
            ),
            hintStyle: context.pAppStyle.interRegularBase.copyWith(
              color: context.pColorScheme.textSecondary,
              fontSize: Grid.m - Grid.xxs,
            ),
            suffixIcon: isShowSuffixIcon ?? true
                ? Transform.scale(
                    scale: 0.4,
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      ImagesPath.chevron_down,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        value == L10n.tr('choose') ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
