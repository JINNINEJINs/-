import cv2
import mediapipe as mp
import numpy as np
from tensorflow import keras

# ===== load model =====
model = keras.models.load_model("model/hand_model.h5")

mp_hands = mp.solutions.hands
mp_draw = mp.solutions.drawing_utils

hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=2,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.5
)

cap = cv2.VideoCapture(0)

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1)
    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    result = hands.process(rgb)

    if result.multi_hand_landmarks:
        # Draw all detected hands
        for hand in result.multi_hand_landmarks:
            mp_draw.draw_landmarks(frame, hand, mp_hands.HAND_CONNECTIONS)

        # Collect landmarks from both hands
        data = []
        for hand_idx in range(min(2, len(result.multi_hand_landmarks))):
            for lm in result.multi_hand_landmarks[hand_idx].landmark:
                data.extend([lm.x, lm.y])
        
        # If only 1 hand detected, pad with zeros for the 2nd hand
        while len(data) < 84:  # 2 hands × 21 landmarks × 2 coordinates
            data.append(0.0)

        X = np.array(data).reshape(1, -1)

        pred = model.predict(X, verbose=0)[0]
        label = np.argmax(pred)
        confidence = pred[label] * 100

        cv2.putText(
            frame,
            f"Pred: {label} ({confidence:.1f}%)",
            (30, 50),
            cv2.FONT_HERSHEY_SIMPLEX,
            1,
            (0, 255, 0),
            2
        )

    cv2.imshow("Hand Sign Recognition", frame)

    if cv2.waitKey(1) & 0xFF == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()
