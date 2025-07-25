// import 'package:design_system/components/alert/alert.dart';
// import 'package:design_system/components/app_bar/app_bar.dart';
// import 'package:design_system/components/snackbar/snack_bar.dart';
// import 'package:design_system/extension/theme_context_extension.dart';
// import 'package:design_system/foundations/spacing/grid.dart';
// import 'package:flutter/material.dart';

// class AlertCatalogPage extends StatelessWidget {
//   const AlertCatalogPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PAppBarCoreWidget(title: 'Alert catalog'),
//       body: Container(
//         color: context.pColorScheme.lightHigh,
//         child: ListView(
//           padding: const EdgeInsets.all(Grid.m),
//           children: <Widget>[
//             ..._infoAlerts(context),
//             const Divider(height: Grid.l, thickness: 2),
//             ..._successAlerts(context),
//             const Divider(height: Grid.l, thickness: 2),
//             ..._criticalAlerts(context),
//             const Divider(height: Grid.l, thickness: 2),
//             ..._warningAlerts(context),
//             const Divider(height: Grid.l, thickness: 2),
//             ..._neutralAlerts(context),
//             const Divider(height: Grid.l, thickness: 2),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _infoAlerts(BuildContext context) {
//     return [
//       const PAlert.info(
//         messageHeader: 'Title',
//         message: 'Info alert content',
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.info(
//         messageHeader: 'Title',
//         message: 'Info alert with long text, info alert with long text, info alert with long text',
//         multiline: false,
//         dismissible: true,
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.info(
//         messageHeader: 'Title',
//         message: 'Info alert multiline',
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         dismissible: true,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.info(
//         message: 'Info alert single line',
//         multiline: false,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         primaryActionText: 'Primary',
//       ),
//     ];
//   }

//   List<Widget> _successAlerts(BuildContext context) {
//     return [
//       const PAlert.success(
//         messageHeader: 'Title',
//         message: 'Info alert content',
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.success(
//         messageHeader: 'Title',
//         message: 'Info alert with long text, info alert with long text, info alert with long text',
//         multiline: false,
//         dismissible: true,
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.success(
//         messageHeader: 'Title',
//         message: 'Info alert multiline',
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         dismissible: true,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.success(
//         message: 'Info alert single line',
//         multiline: false,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         primaryActionText: 'Primary',
//       ),
//     ];
//   }

//   List<Widget> _criticalAlerts(BuildContext context) {
//     return [
//       const PAlert.critical(
//         messageHeader: 'Title',
//         message: 'Info alert content',
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.critical(
//         messageHeader: 'Title',
//         message: 'Info alert with long text, info alert with long text, info alert with long text',
//         multiline: false,
//         dismissible: true,
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.critical(
//         messageHeader: 'Title',
//         message: 'Info alert multiline',
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         dismissible: true,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.critical(
//         message: 'Info alert single line',
//         multiline: false,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         primaryActionText: 'Primary',
//       ),
//     ];
//   }

//   List<Widget> _warningAlerts(BuildContext context) {
//     return [
//       const PAlert.warning(
//         messageHeader: 'Title',
//         message: 'Info alert content',
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.warning(
//         messageHeader: 'Title',
//         message: 'Info alert with long text, info alert with long text, info alert with long text',
//         multiline: false,
//         dismissible: true,
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.warning(
//         messageHeader: 'Title',
//         message: 'Info alert multiline',
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         dismissible: true,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.warning(
//         message: 'Info alert single line',
//         multiline: false,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         primaryActionText: 'Primary',
//       ),
//     ];
//   }

//   List<Widget> _neutralAlerts(BuildContext context) {
//     return [
//       const PAlert.neutral(
//         messageHeader: 'Title',
//         message: 'Info alert content',
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.neutral(
//         messageHeader: 'Title',
//         message: 'Info alert with long text, info alert with long text, info alert with long text',
//         multiline: false,
//         dismissible: true,
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.neutral(
//         messageHeader: 'Title',
//         message: 'Info alert multiline',
//         primaryActionText: 'Primary',
//         secondaryActionText: 'Secondary',
//         dismissible: true,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         onSecondaryAction: () {
//           showPSnackBar(
//             'Secondary is clicked',
//             context: context,
//           );
//         },
//       ),
//       const SizedBox(height: Grid.m),
//       PAlert.neutral(
//         message: 'Info alert single line',
//         multiline: false,
//         onPrimaryAction: () {
//           showPSnackBar(
//             'Primary is clicked',
//             context: context,
//           );
//         },
//         primaryActionText: 'Primary',
//       ),
//     ];
//   }
// }
