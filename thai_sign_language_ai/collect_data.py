import cv2
import mediapipe as mp
import csv
import numpy as np

LABEL = input("ใส่ label (เช่น ก หรือ 1): ")

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=1,
    min_detection_confidence=0.7
)

cap = cv2.VideoCapture(0)

with open("dataset.csv", "a", newline="") as f:
    writer = csv.writer(f)

    print("กด S เพื่อบันทึก / Q เพื่อออก")

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        img_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        result = hands.process(img_rgb)

        if result.multi_hand_landmarks:
            hand = result.multi_hand_landmarks[0]
            wrist = hand.landmark[0]

            data = []
            for lm in hand.landmark:
                data.extend([
                    lm.x - wrist.x,
                    lm.y - wrist.y,
                    lm.z - wrist.z
                ])

            cv2.putText(frame, f"Label: {LABEL}",
                        (10, 40), cv2.FONT_HERSHEY_SIMPLEX,
                        1, (0,255,0), 2)

        cv2.imshow("Collect Data", frame)

        key = cv2.waitKey(1) & 0xFF
        if key == ord('s') and result.multi_hand_landmarks:
            writer.writerow(data + [LABEL])
            print("Saved")
        elif key == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()
