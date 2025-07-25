import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/global_onboarding_textfield_widget.dart';

class PersonalInformationTile extends StatelessWidget {
  final String? value;
  final String keys;
  final Function()? onTap;
  final bool editable;

  const PersonalInformationTile({
    super.key,
    this.value,
    required this.keys,
    this.onTap,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Grid.s,
      ),
      child: InkWell(
        onTap: onTap,
        child: GlobalOnboardingTextfieldWidget(
          value: value,
          editable: editable,
          keys: keys,
        ),
      ),
    );
  }
}
