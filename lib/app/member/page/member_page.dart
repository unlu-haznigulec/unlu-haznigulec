import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/selection_control/checkbox.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/components/text_field/text_field.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/app/member/bloc/member_bloc.dart';
import 'package:piapiri_v2/app/member/bloc/member_event.dart';
import 'package:piapiri_v2/app/member/bloc/member_state.dart';
import 'package:piapiri_v2/common/utils/phone_number_formatter.dart';
import 'package:piapiri_v2/common/widgets/custom_keyboard_textfield_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _surnameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isSelectedKVKK = false;
  bool _isSelectedETK = false;
  late MemberBloc _memberBloc;

  final ValueNotifier<String> _nameNotifier = ValueNotifier('');
  final ValueNotifier<String> _surnameNotifier = ValueNotifier('');
  final ValueNotifier<String> _phoneNotifier = ValueNotifier('');
  final ValueNotifier<String> _emailNotifier = ValueNotifier('');
  final ValueNotifier<bool> _isValid = ValueNotifier(false);

  @override
  void initState() {
    _memberBloc = getIt<MemberBloc>();
    getIt<Analytics>().track(
      AnalyticsEvents.splashTryNowFormView,
    );
    _nameController.addListener(_updateNameAndValidate);
    _surnameController.addListener(_updateSurnameAndValidate);
    _phoneNoController.addListener(_updatePhoneAndValidate);
    _emailController.addListener(_updateEmailAndValidate);
    super.initState();
  }

  void _updateNameAndValidate() {
    _nameNotifier.value = _nameController.text;
    _checkFormValidity();
  }

  void _updateSurnameAndValidate() {
    _surnameNotifier.value = _surnameController.text;
    _checkFormValidity();
  }

  void _updatePhoneAndValidate() {
    _phoneNotifier.value = _phoneNoController.text;
    _checkFormValidity();
  }

  void _updateEmailAndValidate() {
    _emailNotifier.value = _emailController.text;
    _checkFormValidity();
  }

  void _checkFormValidity() {
    _isValid.value = _validateForm();
  }

  bool _validateForm() {
    // Zorunlu alanlar dolu mu kontrolü
    final requiredFieldsFilled =
        _nameNotifier.value.isNotEmpty && _surnameNotifier.value.isNotEmpty && _phoneNotifier.value.isNotEmpty;

    // Telefon formatı doğru mu
    final phoneValid = _validatePhone(_phoneNotifier.value);

    // Email ya boş ya da geçerli format
    final emailValid = _emailNotifier.value.isEmpty || _validateEmail(_emailNotifier.value);

    return requiredFieldsFilled && phoneValid && emailValid && _isSelectedKVKK;
  }

  bool _validatePhone(String phone) {
    if (phone.isEmpty) return false;
    const pattern = r'^5\d{2} \d{3} \d{2} \d{2}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(phone);
  }

  bool _validateEmail(String email) {
    if (email.isEmpty) return true;
    const pattern = r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateNameAndValidate);
    _surnameController.removeListener(_updateSurnameAndValidate);
    _phoneNoController.removeListener(_updatePhoneAndValidate);
    _emailController.removeListener(_updateEmailAndValidate);
    _nameNotifier.dispose();
    _surnameNotifier.dispose();
    _phoneNotifier.dispose();
    _emailNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<MemberBloc, MemberState>(
        bloc: _memberBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: const PInnerAppBar(
              dividerHeight: 0,
              title: '',
            ),
            persistentFooterButtons: [
              ValueListenableBuilder<bool>(
                valueListenable: _isValid,
                builder: (context, isValid, child) => PButton(
                  text: L10n.tr('devam'),
                  fillParentWidth: true,
                  onPressed: state.isLoading || !isValid
                      ? null
                      : () {
                          if (_isSelectedKVKK) {
                            getIt<Analytics>().track(
                              AnalyticsEvents.tryNowFormViewContinueButton,
                              taxonomy: [
                                InsiderEventEnum.memberPage.value,
                              ],
                            );
                            _memberBloc.add(
                              MemberRequestOtpEvent(
                                gsm: '0${_phoneNoController.text}',
                                onSuccess: (response) {
                                  router.push(
                                    MemberOtpRoute(
                                      fullName: '${_nameController.text} ${_surnameController.text}',
                                      gsm: '0${_phoneNoController.text}',
                                      email: _emailController.text,
                                      kvkk: _isSelectedKVKK,
                                      etk: _isSelectedETK,
                                      otpTimeout: response.data['otpTimeout'],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            PBottomSheet.showError(
                              context,
                              content: L10n.tr('lets_try_kvkk_alert'),
                              isDismissible: true,
                              showFilledButton: true,
                              filledButtonText: L10n.tr('tamam'),
                              onFilledButtonPressed: () => router.maybePop(),
                            );
                          }
                        },
                ),
              ),
            ],
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Grid.m),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        L10n.tr('welcome_piapiri'),
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg18textPrimary,
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      Text(
                        L10n.tr(
                          'lets_try_description',
                        ),
                        style: context.pAppStyle.interRegularBase.copyWith(
                          fontSize: Grid.m - Grid.xxs,
                          color: context.pColorScheme.textPrimary,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _nameNotifier,
                        builder: (context, value, child) => PTextField(
                          controller: _nameController,
                          label: '${L10n.tr('ad')}*',
                          labelColor: context.pColorScheme.textSecondary,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                          hasText: value.isNotEmpty,
                          validator: PValidator(
                            focusNode: _nameFocusNode,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return L10n.tr('lets_try_name_validity');
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _surnameNotifier,
                        builder: (context, value, child) => PTextField(
                          controller: _surnameController,
                          label: '${L10n.tr('soyad')}*',
                          labelColor: context.pColorScheme.textSecondary,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                          hasText: value.isNotEmpty,
                          validator: PValidator(
                            focusNode: _surnameFocusNode,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return L10n.tr('lets_try_surname_validity');
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _emailNotifier,
                        builder: (context, value, child) => PTextField.email(
                          controller: _emailController,
                          label: L10n.tr('lets_try_email'),
                          labelColor: context.pColorScheme.textSecondary,
                          hasText: value.isNotEmpty,
                          validator: PValidator(
                            focusNode: _emailFocusNode,
                            validate: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!_validateEmail(value)) {
                                  return L10n.tr('lets_try_valid_email_validity');
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      CustomKeyboardTextfieldWidget(
                        showSeperator: false,
                        focusNode: _phoneFocusNode,
                        controller: _phoneNoController,
                        label: '${L10n.tr('lets_try_phone')}*',
                        textStyle: context.pAppStyle.labelMed16textPrimary,
                        labelStyle: context.pAppStyle.labelReg16textSecondary,
                        focusedLabelStyle: context.pAppStyle.labelMed12textSecondary,
                        validator: PValidator(
                          focusNode: _phoneFocusNode,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return L10n.tr('lets_try_phone_validity');
                            }
                            if (!_validatePhone(value)) {
                              return L10n.tr('lets_try_valid_phone_validity');
                            }
                            return null;
                          },
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                          PhoneNumberFormatter()
                        ],
                      ),
                      const SizedBox(height: Grid.m),
                      PCheckboxRow(
                        value: _isSelectedKVKK,
                        removeCheckboxPadding: true,
                        labelWidget: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: L10n.tr('member_kvkk_richText'),
                                style: context.pAppStyle.labelReg14primary,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    router.push(
                                      MemberPdfRoute(
                                        selectedKVKK: (bool selectedKVKK) {
                                          setState(() {
                                            _isSelectedKVKK = selectedKVKK;
                                            _checkFormValidity();
                                          });
                                        },
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: L10n.tr('member_kvkk_richTextContinue'),
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (bool? value) {
                          if (value == true && _isSelectedKVKK == false) {
                            router.push(
                              MemberPdfRoute(
                                selectedKVKK: (bool selectedKVKK) {
                                  setState(() {
                                    _isSelectedKVKK = selectedKVKK;
                                    _checkFormValidity();
                                  });
                                },
                              ),
                            );
                          } else {
                            setState(() {
                              _isSelectedKVKK = value == true;
                              _checkFormValidity();
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: Grid.xs,
                      ),
                      PCheckboxRow(
                        value: _isSelectedETK,
                        removeCheckboxPadding: true,
                        label: L10n.tr('member_etk'),
                        onChanged: (bool? value) {
                          setState(() {
                            _isSelectedETK = value == true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
