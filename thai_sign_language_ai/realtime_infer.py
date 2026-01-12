import cv2
import mediapipe as mp
import numpy as np
from tensorflow.keras.models import load_model

model = load_model("sign_model.h5")

with open("labels.txt", encoding="utf-8") as f:
    labels = f.read().splitlines()

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(max_num_hands=1)

cap = cv2.VideoCapture(0)

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

        pred = model.predict(np.array([data]), verbose=0)
        idx = np.argmax(pred)
        conf = np.max(pred)

        cv2.putText(frame,
                    f"{labels[idx]} ({conf:.2f})",
                    (10, 50),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    1.2,
                    (0,255,0),
                    3)

    cv2.imshow("Thai Sign AI", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
