import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Hand',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: CameraWidget(),
    );
  }
}
class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  String currentGesture = "กำลังตรวจจับ...";
  List<String> history = ["สวัสดี", "ขอบคุณ", "ใช่"];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Hand Translator"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          /// ================= CAMERA VIEW =================
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  width: w,
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      "CAMERA PREVIEW",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),

                /// Overlay ผลลัพธ์ AI
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.pan_tool_alt,
                            color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          currentGesture,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ================= CONTROL PANEL =================
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _controlButton(
                    icon: Icons.cameraswitch,
                    label: "สลับกล้อง",
                  ),
                  _controlButton(
                    icon: Icons.camera_alt,
                    label: "เปิดกล้อง",
                  ),
                  _controlButton(
                    icon: Icons.settings,
                    label: "ตั้งค่า",
                  ),
                ],
              ),
            ),
          ),

          /// ================= HISTORY =================
          Expanded(
            flex: 3,
            child: Container(
              width: w,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ผลลัพธ์ล่าสุด",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(history[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
