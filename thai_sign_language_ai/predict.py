import mediapipe as mp
import numpy as np
from tensorflow import keras

model = keras.models.load_model("model/hand_model.h5")

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=2,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.5
)

def predict_from_rgb(rgb):
    result = hands.process(rgb)
    if not result.multi_hand_landmarks:
        return None

    data = []
    for hand_idx in range(min(2, len(result.multi_hand_landmarks))):
        for lm in result.multi_hand_landmarks[hand_idx].landmark:
            data.extend([lm.x, lm.y])

    while len(data) < 84:
        data.append(0.0)

    X = np.array(data).reshape(1, -1)
    pred = model.predict(X, verbose=0)[0]

    label = int(np.argmax(pred))
    confidence = float(pred[label] * 100)

    return label, confidence
