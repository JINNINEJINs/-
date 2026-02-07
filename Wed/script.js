const video = document.getElementById("camera");
const gestureText = document.getElementById("gesture");
const historyList = document.getElementById("historyList");

let currentStream;
let useFrontCamera = true;

// เปิดกล้อง
async function startCamera() {
  if (currentStream) {
    currentStream.getTracks().forEach(track => track.stop());
  }

  const constraints = {
    video: {
      facingMode: useFrontCamera ? "user" : "environment"
    }
  };

  currentStream = await navigator.mediaDevices.getUserMedia(constraints);
  video.srcObject = currentStream;
}

startCamera();

// สลับกล้อง
function switchCamera() {
  useFrontCamera = !useFrontCamera;
  startCamera();
}

// ===== ตัวอย่างจำลองผล AI =====
setInterval(() => {
  const gestures = [];
  const result = gestures[Math.floor(Math.random() * gestures.length)];

  gestureText.innerText = result;

  const li = document.createElement("li");
  li.innerText = result;
  historyList.prepend(li);

  if (historyList.children.length > 5) {
    historyList.removeChild(historyList.lastChild);
  }
}, 3000);
