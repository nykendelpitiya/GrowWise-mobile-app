from fastapi import APIRouter
from pydantic import BaseModel

from services.translate_service import translate_text

router = APIRouter()


class TranslateRequest(BaseModel):
    text: str
    lang: str


@router.post("/translate")
def translate(request: TranslateRequest):
    translated_text = translate_text(
        request.text,
        request.lang,
    )

    return {
        "success": True,
        "text": request.text,
        "lang": request.lang,
        "translated": translated_text,
    }