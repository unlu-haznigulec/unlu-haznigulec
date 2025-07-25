import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/picker/date_pickers.dart';
import 'package:design_system/components/progress_indicator/progress_indicator.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/components/text_field/text_field.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_state.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/phone_number_formatter.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IndividualPasswordPage extends StatefulWidget {
  const IndividualPasswordPage({super.key});

  @override
  State<IndividualPasswordPage> createState() => _IndividualPasswordPageState();
}

//Bireysel Hesap
class _IndividualPasswordPageState extends State<IndividualPasswordPage> with AutomaticKeepAliveClientMixin {
  final TextEditingController _tcNoTC = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _mobilePhoneTC = TextEditingController();
  bool isChoosenDate = false;
  DateTime? _dateOfBirthDateTime;
  late AuthBloc _authBloc;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _tcNoTC.dispose();
    _mobilePhoneTC.dispose();
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
                            label: L10n.tr('tc_no'),
                            controller: _tcNoTC,
                            maxLength: 11,
                            textInputAction: TextInputAction.done,
                            labelColor: context.pColorScheme.textSecondary,
                          ),
                          const SizedBox(
                            height: Grid.m + Grid.xs,
                          ),
                          PTextField.phone(
                            label: L10n.tr('mobile_phone'),
                            controller: _mobilePhoneTC,
                            prefixText: '+90 ',
                            labelColor: context.pColorScheme.textSecondary,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [PhoneNumberFormatter()],
                          ),
                          const SizedBox(
                            height: Grid.m + Grid.xs,
                          ),
                          InkWell(
                            onTap: () async => showPDatePicker(
                              context: context,
                              initialDate: _dateOfBirthDateTime,
                              doneTitle: L10n.tr('tamam'),
                              cancelTitle: L10n.tr('iptal'),
                              onChanged: (selectedDate) {
                                setState(() {
                                  _dateController.text = DateTimeUtils.dateFormat(selectedDate ?? DateTime.now());
                                  _dateOfBirthDateTime = selectedDate;
                                });
                              },
                            ),
                            child: PTextField(
                              label: L10n.tr('birth'),
                              controller: _dateController,
                              maxLength: 11,
                              enabled: false,
                              labelColor: context.pColorScheme.textSecondary,
                              onChanged: (selectedDate) {
                                setState(() {
                                  _dateOfBirthDateTime = DateTime.parse(selectedDate);
                                });
                              },
                              suffixWidget: Transform.scale(
                                scale: 0.4,
                                child: SvgPicture.asset(
                                  ImagesPath.calendar,
                                  width: 17,
                                  height: 17,
                                  colorFilter: ColorFilter.mode(
                                    context.pColorScheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
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
    KeyboardUtils.dismissKeyboard();

    if (_tcNoTC.text.isEmpty || _mobilePhoneTC.text.isEmpty || _dateOfBirthDateTime == null) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_tum_alanlari_doldurunuz'),
      );
    }

    if (_tcNoTC.text.toString().length != 11) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr(
          'tc_no_limit_alert',
          args: ['11'],
        ),
      );
    }

    if (_mobilePhoneTC.text.replaceAll(' ', '').length != 10) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr(
          'phone_limit_alert',
          args: ['10'],
        ),
      );
    }

    _authBloc.add(
      ForgotPasswordEvent(
        tcNo: _tcNoTC.text,
        cellPhone: _mobilePhoneTC.text.replaceAll(' ', ''),
        birthDate: _dateOfBirthDateTime!.formatToJson(),
        taxNo: '',
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
                        isSuccess: true,
                        content: L10n.tr('password_successfully_reset'),
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
