import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class CreateAccountPage extends StatelessWidget {
  final bool isFirstLaunch;
  final bool goHomePage;
  const CreateAccountPage({
    this.isFirstLaunch = false,
    this.goHomePage = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    getIt<Analytics>().track(
      AnalyticsEvents.splashView,
    );
    Map<dynamic, dynamic> hasMembership = {'status': false, 'gsm': ''};
    getIt<AppInfoBloc>().add(
      ReadHasMembershipEvent(
        callback: (callback) {
          hasMembership = callback;
        },
      ),
    );
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        color: context.pColorScheme.transparent,
                        child: AutoSizeText(
                          L10n.tr('all_investment_needs'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: context.pAppStyle.labelMed16primary.copyWith(
                            fontSize: 20,
                          ),
                          minFontSize: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: context.pColorScheme.transparent,
                        child: Image.asset(
                          ImagesPath.firstLogin,
                          scale: 2,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.l,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    L10n.tr('welcome_piapiri'),
                    textAlign: TextAlign.center,
                    style: context.pAppStyle.labelMed20textPrimary,
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                    child: Text(
                      L10n.tr(
                        'create_account_page_description',
                      ),
                      style: context.pAppStyle.labelReg16textPrimary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: Grid.l + Grid.xs,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                    child: Row(
                      children: [
                        Expanded(
                          child: POutlinedButton(
                            text: L10n.tr('hemen_dene'),
                            onPressed: () {
                              getIt<Analytics>().track(
                                AnalyticsEvents.splashTryNowClick,
                              );

                              if (!hasMembership['status']) {
                                router.push(
                                  const MemberRoute(),
                                );
                              } else {
                                router.replaceAll([
                                  DashboardRoute(
                                    key: ValueKey('${DashboardRoute.name}-${DateTime.now().millisecondsSinceEpoch}'),
                                  ),
                                ]);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: Grid.s),
                        Expanded(
                          child: PButton(
                            onPressed: () async {
                              await getIt<Analytics>().track(
                                AnalyticsEvents.splashRegisterClick,
                              );
                              getIt<Analytics>().track(
                                AnalyticsEvents.videoCallSignUpClick,
                                taxonomy: [
                                  InsiderEventEnum.createAccountPage.value,
                                ],
                              );
                              await const MethodChannel('PIAPIRI_CHANNEL').invokeMethod('initEnqura');
                            },
                            text: L10n.tr('hesap_ac'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: L10n.tr('account_already_exist_question'),
                          style: context.pAppStyle.labelReg16textPrimary,
                        ),
                        TextSpan(
                          text: ' ${L10n.tr('splash_login')}',
                          style: context.pAppStyle.labelReg16textPrimary.copyWith(
                            color: context.pColorScheme.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              getIt<Analytics>().track(
                                AnalyticsEvents.splashLoginClick,
                              );
                              router.push(
                                AuthRoute(),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: Grid.l,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
