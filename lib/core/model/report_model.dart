import 'package:piapiri_v2/common/utils/date_time_utils.dart';

class ReportModel {
  final String title;
  final String description;
  final String date;
  final String file;
  final List<dynamic> symbols;
  final String type;
  final int typeId;
  final String icon;
  final String dateTime;
  final Map<String, dynamic>? institutionCodeSymbolMap;

  const ReportModel({
    required this.title,
    required this.description,
    required this.date,
    required this.file,
    this.symbols = const [],
    required this.type,
    required this.typeId,
    required this.icon,
    required this.dateTime,
    this.institutionCodeSymbolMap,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      file: json['file'],
      type: json['contentType'],
      typeId: json['contentTypeId'],
      icon: json['icon'],
      symbols: json['symbols'],
      dateTime: DateTimeUtils.parseMultiLangDate(json['dateTime'])?.toString() ?? '',
      institutionCodeSymbolMap: json['institutionCodeSymbolMap'],
    );
  }
}

class ReportFilterModel {
  final bool showAnalysis;
  final bool showReports;
  final bool showPodcasts;
  final bool showVideoComments;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportFilterModel({
    this.showAnalysis = true,
    this.showReports = true,
    this.showPodcasts = true,
    this.showVideoComments = true,
    this.startDate,
    this.endDate,
  });

  ReportFilterModel copyWith({
    bool? showAnalysis,
    bool? showReports,
    bool? showPodcasts,
    bool? showVideoComments,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ReportFilterModel(
      showAnalysis: showAnalysis ?? this.showAnalysis,
      showReports: showReports ?? this.showReports,
      showPodcasts: showPodcasts ?? this.showPodcasts,
      showVideoComments: showVideoComments ?? this.showVideoComments,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
