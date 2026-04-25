from firebase_admin import messaging
from firebase_init import db


def get_users_debug():
    users = []

    for doc in db.collection("users").stream():
        data = doc.to_dict()
        users.append({
            "doc_id": doc.id,
            "email": data.get("email"),
            "has_fcmToken": "fcmToken" in data,
            "keys": list(data.keys()),
        })

    return {"users": users}


def send_notification_to_email(email: str, title: str, body: str):
    email = email.strip().lower()

    matched_user = None
    matched_user_id = None

    for doc in db.collection("users").stream():
        data = doc.to_dict()
        user_email = str(data.get("email", "")).strip().lower()

        if user_email == email:
            matched_user = data
            matched_user_id = doc.id
            break

    if matched_user is None:
        return {
            "success": False,
            "message": "User email not found",
            "email": email,
        }

    token = matched_user.get("fcmToken")

    if not token:
        return {
            "success": False,
            "message": "FCM token not found",
            "user_id": matched_user_id,
            "available_keys": list(matched_user.keys()),
        }

    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        token=token,
    )

    response = messaging.send(message)

    return {
        "success": True,
        "message": "Notification sent",
        "user_id": matched_user_id,
        "response": response,
    }