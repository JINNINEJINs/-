import cv2
import mediapipe as mp
import csv
import os

mp_hands = mp.solutions.hands
mp_draw = mp.solutions.drawing_utils

hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=2,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.5
)

os.makedirs("data", exist_ok=True)
f = open("data/hand_landmarks.csv", "a", newline="", encoding="utf-8")
writer = csv.writer(f)

cap = cv2.VideoCapture(0)
label = input("กรอก label (0-9 หรือ ก-ฮ): ")

print("กด s = บันทึก | q = ออก")

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1)
    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    result = hands.process(rgb)

    if result.multi_hand_landmarks:
        for hand in result.multi_hand_landmarks:
            mp_draw.draw_landmarks(frame, hand, mp_hands.HAND_CONNECTIONS)

    cv2.imshow("Collect Data", frame)

    key = cv2.waitKey(1) & 0xFF
    if key == ord('s') and result.multi_hand_landmarks:
        row = []
        # Collect landmarks from both hands
        for hand_idx in range(min(2, len(result.multi_hand_landmarks))):
            for lm in result.multi_hand_landmarks[hand_idx].landmark:
                row.extend([lm.x, lm.y])
        # If only 1 hand detected, pad with zeros for the 2nd hand
        while len(row) < 84:  # 2 hands × 21 landmarks × 2 coordinates
            row.append(0.0)
        row.append(label)
        writer.writerow(row)
        print(f"Saved: {label}")

    if key == ord('q'):
        break

cap.release()
f.close()
cv2.destroyAllWindows()
