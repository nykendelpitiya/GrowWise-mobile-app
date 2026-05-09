from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime, timezone
from firebase_admin import messaging
from firebase_init import db


def send_due_notifications():
    print("⏰ Checking due notifications:", datetime.now())

    now = datetime.now(timezone.utc)

    try:
        due_notifications = (
            db.collection("notifications")
            .where("sent", "==", False)
            .where("scheduledAt", "<=", now)
            .stream()
        )

        for notification_doc in due_notifications:
            notification_id = notification_doc.id
            data = notification_doc.to_dict()

            user_id = data.get("userId")
            title = data.get("title", "GrowWise Reminder")
            body = data.get("message") or data.get("body") or ""

            if not user_id:
                print("⚠️ Missing userId:", notification_id)
                continue

            user_doc = db.collection("users").document(user_id).get()

            if not user_doc.exists:
                print("⚠️ User not found:", user_id)
                continue

            user_data = user_doc.to_dict()
            token = user_data.get("fcmToken")

            if not token:
                print("⚠️ No FCM token for user:", user_id)
                continue

            try:
                message = messaging.Message(
                    notification=messaging.Notification(
                        title=title,
                        body=body,
                    ),
                    data={
                        "notificationId": str(notification_id),
                        "type": str(data.get("type", "general")),
                        "category": str(data.get("category", "General")),
                        "crop": str(data.get("crop", "")),
                        "district": str(data.get("district", "")),
                    },
                    token=token,
                )

                response = messaging.send(message)

                db.collection("notifications").document(notification_id).update({
                    "sent": True,
                    "sentAt": datetime.now(timezone.utc),
                    "response": str(response),
                })

                print("✅ Due notification sent:", user_id, title)

            except Exception as e:
                db.collection("notifications").document(notification_id).update({
                    "sendError": str(e),
                    "lastTriedAt": datetime.now(timezone.utc),
                })

                print("❌ Send failed:", user_id, e)

    except Exception as e:
        print("❌ Scheduler job failed:", e)


scheduler = BackgroundScheduler()


def start_scheduler():
    if not scheduler.running:
        scheduler.add_job(
            send_due_notifications,
            trigger="interval",
            minutes=5,
            id="send_due_notifications",
            replace_existing=True,
        )

        scheduler.start()
        print("🚀 Scheduler started...")
    else:
        print("⚠️ Scheduler already running...")