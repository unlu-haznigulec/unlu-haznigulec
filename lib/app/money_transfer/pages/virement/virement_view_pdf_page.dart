import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/money_transfer/model/virement_institution_model.dart';
import 'package:piapiri_v2/app/money_transfer/utils/utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class VirementViewPdfPage extends StatelessWidget {
  final String title;
  final Uint8List uint8List;
  final VirementInstitutionModel? selectedInstitution;
  const VirementViewPdfPage({
    super.key,
    required this.title,
    required this.uint8List,
    this.selectedInstitution,
  });

  @override
  Widget build(BuildContext context) {
    PdfControllerPinch pdfViewController = PdfControllerPinch(
      document: PdfDocument.openData(
        uint8List,
      ),
    );
    File? pdfFile;

    return Scaffold(
      appBar: PInnerAppBar(
        title: title,
        actions: [
          InkWell(
            onTap: () async {
              Uint8List uint8list = await Utils.createVirementPDF(
                selectedInstitution?.institutionName ?? '',
              );
              final box = context.findRenderObject() as RenderBox?;
              final tempDir = await getTemporaryDirectory();
              pdfFile = await File('${tempDir.path}/Piapiri_Virman.pdf').create();
              pdfFile!.writeAsBytesSync(uint8list);
              Share.shareXFiles(
                [
                  XFile(pdfFile!.path, name: 'Piapiri_Virman.pdf'),
                ],
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
              );
            },
            child: SvgPicture.asset(
              ImagesPath.share,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.iconPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            Grid.s,
          ),
          child: Column(
            children: [
              Expanded(
                child: PdfViewPinch(
                  controller: pdfViewController,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
