import numpy as np
import pandas as pd
from tensorflow import keras
from tensorflow.keras import layers
from sklearn.model_selection import train_test_split

# ===== load data =====
df = pd.read_csv("data/hand_landmarks.csv", header=None)

X = df.iloc[:, :-1].values   # 84 ค่า landmark (2 hands × 21 landmarks × 2 coords)
y = df.iloc[:, -1].values   # label 0-9

# ===== split =====
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# ===== model =====
model = keras.Sequential([
    layers.Input(shape=(84,)),  # 2 hands × 21 landmarks × 2 coordinates
    layers.Dense(256, activation="relu"),
    layers.Dense(128, activation="relu"),
    layers.Dense(64, activation="relu"),
    layers.Dense(10, activation="softmax")  # 0–9
])

model.compile(
    optimizer="adam",
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"]
)

# ===== train =====
model.fit(
    X_train, y_train,
    validation_data=(X_test, y_test),
    epochs=30,
    batch_size=16
)

# ===== save =====
model.save("model/hand_model.h5")

print("✅ Train เสร็จ และบันทึกโมเดลแล้ว")
