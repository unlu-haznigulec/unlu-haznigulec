import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/pdf_viewer/pdf_viewer.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MemberPdfPage extends StatefulWidget {
  final Function(bool) selectedKVKK;

  const MemberPdfPage({
    super.key,
    required this.selectedKVKK,
  });

  @override
  State<MemberPdfPage> createState() => _MemberPdfPageState();
}

class _MemberPdfPageState extends State<MemberPdfPage> {
  bool _isLastPage = false;
  late PdfControllerPinch pdfControllerPinch;

  @override
  void initState() {
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(
        InternetFile.get(AppConfig.instance.memberKvkk),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        persistentFooterButtons: [
          PButton(
            text: L10n.tr('onayla'),
            fillParentWidth: true,
            onPressed: _isLastPage
                ? () {
                    widget.selectedKVKK(true);
                    router.maybePop();
                  }
                : null,
          ),
        ],
        body: Column(
          children: [
            Expanded(
              child: PPdfViewer(
                pdfControllerPinch: pdfControllerPinch,
                url: AppConfig.instance.memberKvkk,
                onError: (error) => PBottomSheet.showError(
                  context,
                  content: error.toString(),
                ),
                onPageChanged: (int? page, int? total) {
                  if (page != null && total != null && page == total) {
                    setState(() {
                      _isLastPage = true;
                    });
                  }
                },
                isLast: (isLast) {
                  setState(() {
                    _isLastPage = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
