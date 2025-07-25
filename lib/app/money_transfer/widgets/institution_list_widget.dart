import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/money_transfer/model/virement_institution_model.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

class InstitutionListWidget extends StatelessWidget {
  final List<VirementInstitutionModel>? institutionList;
  final Function(VirementInstitutionModel) onSelectedInstitution;
  const InstitutionListWidget({
    super.key,
    required this.institutionList,
    required this.onSelectedInstitution,
  });

  @override
  Widget build(BuildContext context) {
    return institutionList == null || institutionList!.isEmpty
        ? const SizedBox.shrink()
        : ListView.builder(
            itemCount: institutionList!.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: context.pColorScheme.transparent,
                highlightColor: context.pColorScheme.transparent,
                onTap: () async {
                  await onSelectedInstitution(
                    institutionList![index],
                  );
                  await router.maybePop();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Grid.m,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Grid.s,
                      ),
                      child: Text(
                        institutionList![index].institutionName,
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    const PDivider(),
                  ],
                ),
              );
            },
          );
  }
}
