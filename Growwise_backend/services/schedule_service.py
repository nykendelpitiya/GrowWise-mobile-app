from datetime import datetime, timedelta, time, timezone
from firebase_init import db


def _to_utc_datetime(value):
    if isinstance(value, datetime):
        return value.astimezone(timezone.utc)

    value_str = str(value)
    date_part = datetime.fromisoformat(value_str).date()

    return datetime.combine(
        date_part,
        time(hour=8, minute=0),
        tzinfo=timezone.utc,
    )


def create_schedule_notifications(
    user_id: str,
    crop: str,
    district: str,
    planting_date,
    quantity: int,
    water_total_per_day: float,
    fertilizer_total_per_week: dict,
    splits_per_year: int,
):
    if not user_id:
        raise ValueError("user_id is required")

    crop_clean = crop.strip()
    district_clean = district.strip()

    plant_date = _to_utc_datetime(planting_date).date()
    today = datetime.now(timezone.utc).date()

    # Past planting date නම් today ඉඳන් schedule start
    start_date = max(plant_date, today)

    base_date = datetime.combine(
        start_date,
        time(hour=8, minute=0),
        tzinfo=timezone.utc,
    )

    # Duplicate stop
    existing = (
        db.collection("notifications")
        .where("userId", "==", user_id)
        .where("crop", "==", crop_clean)
        .where("plantingDate", "==", str(planting_date))
        .limit(1)
        .stream()
    )

    if any(existing):
        return {
            "success": True,
            "message": "Notifications already created for this schedule",
        }

    batch = db.batch()
    now = datetime.now(timezone.utc)
    created_count = 0

    # Water reminders - next 30 days
    for day in range(30):
        scheduled_at = base_date + timedelta(days=day)

        doc_ref = db.collection("notifications").document()
        batch.set(doc_ref, {
            "userId": user_id,
            "title": "Water Reminder",
            "message": (
                f"Today water your {crop_clean} plants. "
                f"Required water amount: {round(water_total_per_day, 2)} L "
                f"for {quantity} plants."
            ),
            "type": "water",
            "category": "Water",
            "crop": crop_clean,
            "district": district_clean,
            "quantity": quantity,
            "plantingDate": str(planting_date),
            "scheduledAt": scheduled_at,
            "sent": False,
            "isRead": False,
            "createdAt": now,
        })
        created_count += 1

    # Fertilizer reminders
    splits_per_year = max(1, int(splits_per_year))
    interval_days = max(1, 365 // splits_per_year)

    n_amount = round(float(fertilizer_total_per_week.get("N", 0)), 2)
    p_amount = round(float(fertilizer_total_per_week.get("P2O5", 0)), 2)
    k_amount = round(float(fertilizer_total_per_week.get("K2O", 0)), 2)

    for i in range(splits_per_year):
        scheduled_at = base_date + timedelta(days=i * interval_days)

        doc_ref = db.collection("notifications").document()
        batch.set(doc_ref, {
            "userId": user_id,
            "title": "Fertilizer Reminder",
            "message": (
                f"Today apply fertilizer for your {crop_clean} plants. "
                f"N: {n_amount}, P2O5: {p_amount}, K2O: {k_amount} "
                f"for {quantity} plants."
            ),
            "type": "fertilizer",
            "category": "Fertilizer",
            "crop": crop_clean,
            "district": district_clean,
            "quantity": quantity,
            "plantingDate": str(planting_date),
            "scheduledAt": scheduled_at,
            "sent": False,
            "isRead": False,
            "createdAt": now,
        })
        created_count += 1

    batch.commit()

    return {
        "success": True,
        "message": "Schedule notifications created successfully",
        "created_count": created_count,
        "schedule_start_date": str(start_date),
    }