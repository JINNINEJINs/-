from fastapi import FastAPI, WebSocket
import cv2
import numpy as np
import base64
from predict import predict_from_rgb

app = FastAPI()

@app.websocket("/ws")
async def websocket_endpoint(ws: WebSocket):
    await ws.accept()

    while True:
        data = await ws.receive_text()

        # base64 → image
        img_bytes = base64.b64decode(data)
        np_img = np.frombuffer(img_bytes, np.uint8)
        frame = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        result = predict_from_rgb(rgb)

        if result:
            label, conf = result
            await ws.send_json({
                "label": label,
                "confidence": round(conf, 1)
            })
        else:
            await ws.send_json({"label": None})
