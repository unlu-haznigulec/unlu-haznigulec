import 'package:auto_route/auto_route.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/markets/widgets/advice_history_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AdviceAllHistoryListPage extends StatefulWidget {
  final String mainGroup;
  const AdviceAllHistoryListPage({
    super.key,
    required this.mainGroup,
  });

  @override
  State<AdviceAllHistoryListPage> createState() => _AdviceAllHistoryListPageState();
}

class _AdviceAllHistoryListPageState extends State<AdviceAllHistoryListPage> {
  late AdvicesBloc _advicesBloc;

  @override
  void initState() {
    _advicesBloc = getIt<AdvicesBloc>();

    _advicesBloc.add(
      GetAdviceHistoryEvent(
        mainGroup: widget.mainGroup,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('advices_history'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: SingleChildScrollView(
          child: AdviceHistoryWidget(
            mainGroup: widget.mainGroup,
          ),
        ),
      ),
    );
  }
}
