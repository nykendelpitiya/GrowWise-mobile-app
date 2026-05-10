import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 't.dart';
import 'translate_api_service.dart';

class TText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  State<TText> createState() => _TTextState();
}

class _TTextState extends State<TText> {
  String translatedText = "";
  String lastLanguage = "";

  @override
  void initState() {
    super.initState();
    lastLanguage = T.instance.currentLanguage;
    _translate();
  }

  @override
  void didUpdateWidget(covariant TText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _translate();
    }
  }

  Future<void> _translate() async {
    final lang = T.instance.currentLanguage;
    lastLanguage = lang;

    final cached = T.instance.getTranslation(
      lang: lang,
      key: widget.text,
    );

    if (cached != null) {
      if (mounted) {
        setState(() {
          translatedText = cached;
        });
      }
      return;
    }

    final translated = await TranslateApiService.translateText(
      text: widget.text,
      lang: lang,
    );

    T.instance.saveTranslation(
      lang: lang,
      key: widget.text,
      value: translated,
    );

    if (mounted && lastLanguage == lang) {
      setState(() {
        translatedText = translated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<T>(context);

    if (lastLanguage != languageProvider.currentLanguage) {
      Future.microtask(() {
        if (mounted) {
          _translate();
        }
      });
    }

    return Text(
      translatedText.isEmpty ? widget.text : translatedText,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}