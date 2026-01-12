import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.utils import to_categorical

df = pd.read_csv("dataset.csv", header=None)

X = df.iloc[:, :-1].values
y = df.iloc[:, -1].values

encoder = LabelEncoder()
y_enc = encoder.fit_transform(y)
y_cat = to_categorical(y_enc)

model = Sequential([
    Dense(128, activation='relu', input_shape=(63,)),
    Dense(64, activation='relu'),
    Dense(len(np.unique(y_enc)), activation='softmax')
])

model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

model.fit(X, y_cat, epochs=30, batch_size=32)

model.save("sign_model.h5")

with open("labels.txt", "w", encoding="utf-8") as f:
    for label in encoder.classes_:
        f.write(label + "\n")

print("Train เสร็จ")
