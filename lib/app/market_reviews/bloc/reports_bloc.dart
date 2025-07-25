import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_event.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_state.dart';
import 'package:piapiri_v2/app/market_reviews/repository/reports_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/report_model.dart';

class ReportsBloc extends PBloc<ReportsState> {
  final ReportsRepository _reportsRepository;

  ReportsBloc({
    required ReportsRepository reportsRepository,
  })  : _reportsRepository = reportsRepository,
        super(initialState: const ReportsState()) {
    on<GetReportsEvent>(_onGetReports);
    on<SetReportFilterEvent>(_onSetReportFilter);
  }

  FutureOr<void> _onGetReports(
    GetReportsEvent event,
    Emitter<ReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        reportsState: PageState.loading,
      ),
    );
    ApiResponse response = await _reportsRepository.getReports(
      mainGroup: event.mainGroup,
      showAnalysis: state.reportFilter.showAnalysis,
      showReport: state.reportFilter.showReports,
      showPodcast: state.reportFilter.showPodcasts,
      showVideoComment: state.reportFilter.showVideoComments,
      language: getIt<LanguageBloc>().state.languageCode,
      deviceId: event.deviceId,
      startDate: state.reportFilter.startDate,
      endDate: state.reportFilter.endDate,
    );

    List<ReportModel> reports = [];
    if (response.success) {
      if (response.data != null && response.data['mobileAnalysisList'] != null) {
        reports =
            response.data['mobileAnalysisList'].map<ReportModel>((dynamic json) => ReportModel.fromJson(json)).toList();
      }

      emit(
        state.copyWith(
          reportsState: PageState.success,
          reportList: reports,
        ),
      );
    } else {
      emit(
        state.copyWith(
          reportsState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01REP01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetReportFilter(
    SetReportFilterEvent event,
    Emitter<ReportsState> emit,
  ) {
    emit(
      state.copyWith(
        reportFilter: event.reportFilter,
      ),
    );
    add(
      GetReportsEvent(
        deviceId: event.deviceId,
        mainGroup: event.mainGroup,
      ),
    );
  }
}
