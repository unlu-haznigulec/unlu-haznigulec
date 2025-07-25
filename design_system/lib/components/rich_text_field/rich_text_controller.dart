library rich_text_controller;

import 'dart:developer';

import 'package:design_system/components/rich_text_field/rich_text_field.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:p_core/extensions/extension_wrapper.dart';
import 'package:p_core/route/page_navigator.dart';

class PRichTextController extends TextEditingController {
  final bool interaction;
  final List<PRichTextPattern> patterns;

  PRichTextController({
    String? text,
    this.interaction = false,
    List<PRichTextPattern>? patterns,
  })  : patterns = patterns ??= [
          HashTagRichText(),
          URLRichText(),
          MentionText(mentionables: []),
          BoldText(),
          ItalicText(),
        ],
        super(text: text);

  @override
  TextSpan buildTextSpan({BuildContext? context, TextStyle? style, bool? withComposing}) {
    final List<TextSpan> children = [];
    final List<String> matches = [];
    final RegExp allRegex = RegExp(patterns.map((e) => e.pattern.pattern).join('|'));

    text.splitMapJoin(
      allRegex,
      onMatch: (Match m) {
        if (m[0] == null) {
          return '';
        }
        if (!matches.contains(m[0])) {
          matches.add(m[0]!);
        }

        final PRichTextPattern pattern = patterns.firstWhere((element) {
          return element.pattern.allMatches(m[0]!).isNotEmpty;
        });

        children.add(pattern.createTextSpan(style, m[0]!, interaction));

        return '';
      },
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
    );

    return TextSpan(style: style, children: children);
  }
}

abstract class PRichTextPattern {
  final RegExp pattern;

  PRichTextPattern({required this.pattern});

  TextStyle? _alterStyle(TextStyle? style) {
    return style;
  }

  TextSpan createTextSpan(TextStyle? style, String text, bool interaction) {
    return TextSpan(
      text: text,
      style: _alterStyle(style),
    );
  }
}

class HashTagRichText extends PRichTextPattern {
  final Color? color;

  HashTagRichText({this.color}) : super(pattern: RegExp(r'\B#[a-zA-Z0-9]+\b'));

  @override
  TextStyle? _alterStyle(TextStyle? style) {
    return style?.copyWith(color: color ?? PageNavigator.globalContext?.pColorScheme.primary);
  }
}

class URLRichText extends PRichTextPattern {
  final Color? color;
  final void Function(String)? onUrlClicked;

  URLRichText({this.color, this.onUrlClicked})
      : super(
          pattern: RegExp(r'((http|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])?'),
        );

  @override
  TextSpan createTextSpan(TextStyle? style, String text, bool interaction) {
    return TextSpan(
      text: text,
      style: _alterStyle(style),
      recognizer: interaction
          ? (TapGestureRecognizer()
            ..onTap = () {
              String url = text;
              if (!url.startsWith('https')) {
                url = 'https://$url';
              }
              onUrlClicked?.call(url);
            })
          : null,
    );
  }

  @override
  TextStyle? _alterStyle(TextStyle? style) {
    return style?.copyWith(
      color: color ?? PageNavigator.globalContext?.pColorScheme.primary,
      decoration: TextDecoration.underline,
    );
  }
}

class EmailRichText extends PRichTextPattern {
  final Color? color;
  final void Function(String)? onEmailClicked;

  EmailRichText({this.color, this.onEmailClicked})
      : super(
          pattern: RegExp(
            r'(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))?',
          ),
        );

  @override
  TextSpan createTextSpan(TextStyle? style, String text, bool interaction) {
    return TextSpan(
      text: text,
      style: _alterStyle(style),
      recognizer: interaction
          ? (TapGestureRecognizer()
            ..onTap = () {
              onEmailClicked?.call('mailto:$text');
            })
          : null,
    );
  }

  @override
  TextStyle? _alterStyle(TextStyle? style) {
    return style?.copyWith(
      color: color ?? PageNavigator.globalContext?.pColorScheme.primary,
      decoration: TextDecoration.underline,
    );
  }
}

class BoldText extends PRichTextPattern {
  final FontWeight fontWeight;

  BoldText({this.fontWeight = FontWeight.w700}) : super(pattern: RegExp(r'\+(.*?)\+'));

  @override
  TextStyle? _alterStyle(TextStyle? style) {
    return style?.copyWith(fontWeight: fontWeight);
  }

  @override
  TextSpan createTextSpan(TextStyle? style, String text, bool interaction) {
    if (text.length < 3 || !text.startsWith('+') || !text.endsWith('+')) {
      return super.createTextSpan(style, text, interaction);
    }

    return TextSpan(
      text: String.fromCharCodes(Runes('\u{FEFF}')) +
          text.substring(1, text.length - 1) +
          String.fromCharCodes(Runes('\u{FEFF}')),
      style: _alterStyle(style),
    );
  }
}

class ItalicText extends PRichTextPattern {
  ItalicText() : super(pattern: RegExp(r'_[a-zA-Z0-9 \.@!$%\-&:\(\)]+_'));

  @override
  TextStyle? _alterStyle(TextStyle? style) {
    return style?.copyWith(fontStyle: FontStyle.italic);
  }

  @override
  TextSpan createTextSpan(TextStyle? style, String text, bool interaction) {
    if (text.length < 3 || !text.startsWith('_') || !text.endsWith('_')) {
      return super.createTextSpan(style, text, interaction);
    }

    return TextSpan(
      children: [
        TextSpan(text: String.fromCharCodes(Runes('\u{FEFF}')), semanticsLabel: '_'),
        TextSpan(text: text.substring(1, text.length - 1), style: _alterStyle(style)),
        TextSpan(text: String.fromCharCodes(Runes('\u{FEFF}')), semanticsLabel: '_'),
      ],
    );
  }
}

class MentionText extends PRichTextPattern {
  final Color? color;
  final List<Mentionable>? mentionables;
  final Function(Mentionable)? onMentionedTapped;

  MentionText({
    this.color,
    this.mentionables,
    this.onMentionedTapped,
  }) : super(pattern: RegExp(r'@[0-9a-fA-F-]{36}'));

  @override
  TextSpan createTextSpan(TextStyle? style, String text, bool interaction) {
    if (mentionables != null) {
      if (text.startsWith('@') && text.length > 1) {
        final String employeeId = text.substring(1);

        final Mentionable? employee = mentionables!.firstWhereOrNull((e) => e.id == employeeId);

        if (employee != null) {
          String replaced = '@${employee.name}';

          if (replaced.length > text.length) {
            replaced = replaced.substring(0, text.length);
          } else if (replaced.length < text.length) {
            replaced += String.fromCharCodes(Runes('\u{FEFF}')) * (text.length - replaced.length);
          }

          return TextSpan(
            text: replaced,
            style: _alterStyle(style?.copyWith(color: color ?? PageNavigator.globalContext?.pColorScheme.primary)),
            recognizer: interaction
                ? (TapGestureRecognizer()
                  ..onTap = () {
                    onMentionedTapped?.call(employee);
                  })
                : null,
          );
        }
      }
    }

    return TextSpan(text: text, style: style);
  }
}

int findClosestAtSign(int baseOffset, Characters characters) {
  try {
    for (int i = baseOffset - 1; i > baseOffset - 37 && i > -1; i--) {
      if (characters.characterAt(i).toString() == '@') {
        return i;
      }
    }
  } catch (error) {
    log('found an error : $error');
  }
  return -1;
}
