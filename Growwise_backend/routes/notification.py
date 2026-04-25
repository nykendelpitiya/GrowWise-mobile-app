from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from services.fcm_service import send_notification_to_email, get_users_debug

router = APIRouter()


class NotificationRequest(BaseModel):
    email: str
    title: str
    body: str


@router.post("/send-notification")
def send_notification(data: NotificationRequest):
    result = send_notification_to_email(
        email=data.email,
        title=data.title,
        body=data.body,
    )

    if not result["success"]:
        raise HTTPException(status_code=400, detail=result)

    return result


@router.get("/debug-users")
def debug_users():
    return get_users_debug()