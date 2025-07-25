import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/contracts/widget/contracts_question_list_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ContractsSurveyPage extends StatefulWidget {
  final String title;

  const ContractsSurveyPage({
    super.key,
    required this.title,
  });

  @override
  State<ContractsSurveyPage> createState() => _ContractsSurveyPageState();
}

class _ContractsSurveyPageState extends State<ContractsSurveyPage> {
  int page = 1;
  late ContractsBloc _contractsBloc;

  @override
  void initState() {
    _contractsBloc = getIt<ContractsBloc>();
    getIt<ContractsBloc>().add(
      GetSurveyQuestionEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: widget.title,
        actions: page > 1
            ? [
                InkWrapper(
                  child: SvgPicture.asset(
                    ImagesPath.x,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () {
                    PBottomSheet.showError(
                      context,
                      content: L10n.tr('survey_exit_alert'),
                      showFilledButton: true,
                      showOutlinedButton: true,
                      filledButtonText: L10n.tr('tamam'),
                      outlinedButtonText: L10n.tr('vazgeç'),
                      onFilledButtonPressed: () {
                        router.popUntilRouteWithName(
                          ContractsRoute.name,
                        );
                      },
                      onOutlinedButtonPressed: () => router.maybePop(),
                    );
                  },
                ),
              ]
            : null,
        onPressed: () {
          if (page > 1) {
            setState(() {
              page--;
            });
          } else {
            router.maybePop();
          }
        },
      ),
      body: PBlocBuilder<ContractsBloc, ContractsState>(
        bloc: _contractsBloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const PLoading();
          }
          if (state.questions.isEmpty) {
            return NoDataWidget(
              message: L10n.tr(
                'no_data',
              ),
            );
          }
          return ContractsQuestionsListWidget(
            answers: state.answers,
            questions: state.questions,
            onChangePage: (pageNum) {
              setState(() {
                page = pageNum;
              });
            },
            page: page,
          );
        },
      ),
    );
  }
}
