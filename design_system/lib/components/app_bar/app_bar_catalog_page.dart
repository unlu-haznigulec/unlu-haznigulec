import 'package:design_system/components/app_bar/app_bar.dart';
import 'package:design_system/components/selection_control/radio_button.dart';
import 'package:design_system/components/snackbar/snack_bar.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/simple_page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarCatalogPage extends StatefulWidget {
  const AppBarCatalogPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppBarCatalogPageState();
}

class _AppBarCatalogPageState extends State<AppBarCatalogPage> {
  PBaseAppBar? currentAppBar;

  late PBaseAppBar regularAppBar;
  late PBaseAppBar regularAppBarDuringImpersonation;
  late PBaseAppBar searchAppBar;
  late PBaseAppBar cancelAppBar;

  @override
  void initState() {
    super.initState();
    regularAppBar = PAppBarCoreWidget(
      title: 'Regular AppBar',
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => showPSnackBar(
            'Regular AppBar action is clicked.',
            context: context,
          ),
        ),
      ],
    );
    regularAppBarDuringImpersonation = const PAppBarCoreWidget(
      title: 'Regular AppBar (impersonation)',
      isImpersonationEnabled: true,
    );
    searchAppBar = const PSearchAppBar(searchBarHint: 'Search');
    cancelAppBar = PCancelAppBar(
      onPressed: () => SimplePageNavigator.pop(context),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );

    currentAppBar = regularAppBar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentAppBar,
      body: ListView(
        children: <Widget>[
          const SizedBox(height: Grid.m),
          PRadioButtonRow<PBaseAppBar>(
            text: 'Regular AppBar',
            value: regularAppBar,
            groupValue: currentAppBar,
            onChanged: (PBaseAppBar? value) => setState(() => currentAppBar = value),
          ),
          const SizedBox(height: Grid.m),
          PRadioButtonRow<PBaseAppBar>(
            text: 'Regular AppBar (impersonation)',
            value: regularAppBarDuringImpersonation,
            groupValue: currentAppBar,
            onChanged: (PBaseAppBar? value) => setState(() => currentAppBar = value),
          ),
          const SizedBox(height: Grid.m),
          PRadioButtonRow<PBaseAppBar>(
            text: 'Regular AppBar with Search Bar',
            value: searchAppBar,
            groupValue: currentAppBar,
            onChanged: (PBaseAppBar? value) => setState(() => currentAppBar = value),
          ),
          const SizedBox(height: Grid.m),
          PRadioButtonRow<PBaseAppBar>(
            text: 'Cancel AppBar (Note: will be moved to Splash Page template. The component is for developer use)',
            value: cancelAppBar,
            groupValue: currentAppBar,
            onChanged: (PBaseAppBar? value) => setState(() => currentAppBar = value),
          ),
          const SizedBox(height: Grid.m),
        ],
      ),
    );
  }
}
