import 'package:auto_route/auto_route.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/pages/forgot_password/corporate_password_page.dart';
import 'package:piapiri_v2/app/auth/pages/forgot_password/individual_password_page.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(title: L10n.tr('sifremi_unuttum')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: TabBar(
                labelStyle: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m,
                ),
                unselectedLabelStyle: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m,
                ),
                controller: _tabController,
                tabs: [
                  Tab(text: L10n.tr('bireysel_hesap')),
                  Tab(text: L10n.tr('kurumsal_hesap')),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                IndividualPasswordPage(),
                CorporatePasswordPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
