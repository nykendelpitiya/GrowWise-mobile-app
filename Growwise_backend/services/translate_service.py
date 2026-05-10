from deep_translator import GoogleTranslator


def translate_text(text: str, lang: str):
    """
    Translate text to target language.
    lang: en / si / ta
    """

    if not text:
        return text

    if lang == "en":
        return text

    try:
        translated = GoogleTranslator(
            source="auto",
            target=lang,
        ).translate(text)

        return translated

    except Exception as e:
        print("❌ Translate Error:", e)
        return text