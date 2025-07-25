import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/progress_indicator/progress_indicator.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/components/text_field/text_field.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CorporatePasswordPage extends StatefulWidget {
  const CorporatePasswordPage({super.key});

  @override
  State<CorporatePasswordPage> createState() => _CorporatePasswordPageState();
}

class _CorporatePasswordPageState extends State<CorporatePasswordPage> with AutomaticKeepAliveClientMixin {
  final TextEditingController _mobilePhoneTC = TextEditingController();
  final TextEditingController _taxNoTC = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _mobilePhoneTC.dispose();
    _taxNoTC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<AuthBloc, AuthState>(
        bloc: _authBloc,
        builder: (context, state) {
          return state.isLoading
              ? const PCircularProgressIndicator()
              : Scaffold(
                  persistentFooterAlignment: AlignmentDirectional.center,
                  persistentFooterButtons: [
                    PButton(
                      text: L10n.tr('devam'),
                      onPressed: () => _goCheckOtpScreen(),
                      fillParentWidth: true,
                    ),
                  ],
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: Grid.l,
                          ),
                          PTextField.number(
                            controller: _mobilePhoneTC,
                            label: L10n.tr('mobile_phone'),
                            maxLength: 10,
                            prefixText: '+90 ',
                            labelColor: context.pColorScheme.textSecondary,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: Grid.s),
                          PTextField.number(
                            controller: _taxNoTC,
                            label: L10n.tr('vergi_numarasi'),
                            maxLength: 10,
                            labelColor: context.pColorScheme.textSecondary,
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  _goCheckOtpScreen() async {
    if (_taxNoTC.text.isEmpty || _mobilePhoneTC.text.isEmpty) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_tum_alanlari_doldurunuz'),
      );
    }

    if (_taxNoTC.text.toString().length != 10) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_gecerli_bir_vergi_no_giriniz'),
      );
    }

    if (_mobilePhoneTC.text.replaceAll(' ', '').length != 10) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr(
          'lets_try_phone_validity',
          args: ['10'],
        ),
      );
    }

    _authBloc.add(
      ForgotPasswordEvent(
        taxNo: _taxNoTC.text,
        cellPhone: _mobilePhoneTC.text.replaceAll(' ', ''),
        onSuccess: (forgotResponse) async {
          router.push(
            CheckOtpRoute(
              customerExtId: forgotResponse['customerExtId'],
              otpDuration: forgotResponse['otpTimeout'],
              callOtpAfterClickButton: false,
              onOtpValidated: (otp) {
                _authBloc.add(
                  ResetPasswordEvent(
                    customerId: forgotResponse['customerExtId'],
                    otp: otp,
                    onSuccess: () {
                      router.popUntilRouteWithName(AuthRoute.name);
                      PBottomSheet.showError(
                        context,
                        content: L10n.tr('password_successfully_reset'),
                        isSuccess: true,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
