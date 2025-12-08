import 'package:flutter/material.dart';

class CreateThreadPage extends StatefulWidget {
  const CreateThreadPage({super.key});

  @override
  State<CreateThreadPage> createState() => _CreateThreadPageState();
}

class _CreateThreadPageState extends State<CreateThreadPage> {
  bool get isFormValid => title.isNotEmpty && content.isNotEmpty;
  String title = '';
  String content = '';
  bool isUploading = false;
  bool isCreating = false;
  double uploadProgress = 0.0;
  bool showNookPicker = false;

  List<String> selectedImages = [];
  List<Map<String, String>> nooks = [
    {"name": "Nook 1", "description": "Description 1", "imageUrl": ""},
    {"name": "Nook 2", "description": "Description 2", "imageUrl": ""},
  ];
  Map<String, String>? selectedNook;

  void pickImages() {
    // Just placeholder for UI
    setState(() {
      selectedImages.add("image_placeholder");
    });
  }

  void pickNook(Map<String, String> nook) {
    setState(() {
      selectedNook = nook;
      showNookPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262626),
      appBar: AppBar(
        toolbarHeight: 84, // default is 56, increases vertical space
        backgroundColor: const Color(0xFF262626),
        leading: IconButton(
          icon: const Icon(
            Icons.close, // X icon
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0, // optional, aligns title right next to leading
        title: Container(
          height: kToolbarHeight, // ensures it fills the appbar height
          alignment: Alignment.centerLeft, // vertically and horizontally left
          child: Text(
            selectedNook != null
                ? "Start A Thread in ${selectedNook!['name']}"
                : "Start A Thread",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: (isUploading || isCreating || !isFormValid)
                  ? null
                  : () {
                      // your post logic here
                    },

              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(MaterialState.disabled)) {
                    return const Color(0xFF3c3c3c);
                    // your idle color
                  }
                  return Colors.green; // enabled
                }),

                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                ),

                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              child: isUploading || isCreating
                  ? Row(
                      children: const [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFC7C7C7),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Posting...",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC7C7C7),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      "Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isFormValid
                            ? Colors.white
                            : const Color(0xFFC7C7C7),
                        fontSize: 18,
                      ),
                    ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUploading || isCreating || uploadProgress > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: uploadProgress),
                  const SizedBox(height: 8),
                  Text(
                    isUploading
                        ? "Uploading images... ${(uploadProgress * 100).toInt()}%"
                        : isCreating
                        ? "Creating post... ${(uploadProgress * 100).toInt()}%"
                        : "Complete!",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // TITLE INPUT
            TextField(
              decoration: InputDecoration(
                hintText: "Title*",
                hintStyle: const TextStyle(
                  color: Color(0xFFC7C7C7),
                  fontWeight: FontWeight.normal,
                ),
                filled: true,
                fillColor: Color(0xFF262626),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFBEBEBE)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFBEBEBE)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => title = val),
            ),

            const SizedBox(height: 24),

            // PICK A NOOK BUTTON
            if (selectedNook == null)
              ElevatedButton(
                onPressed: () => setState(() => showNookPicker = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF555555),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                ),
                child: Text(
                  "Pick a Nook ::",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // ATTACH IMAGES - JUST UI, WITH DASHED BORDER
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFF262626),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image, size: 40, color: Color(0xFFC7C7C7)),
                      SizedBox(height: 8),
                      Text(
                        "Attach Images",
                        style: TextStyle(
                          color: Color(0xFFC7C7C7),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "Supports multiple images and GIFs",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFC7C7C7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // BODY TEXT
            TextField(
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Body Text",
                hintStyle: const TextStyle(
                  color: Color(0xFFC7C7C7),
                  fontWeight: FontWeight.normal,
                ),
                filled: true,
                fillColor: Color(0xFF262626),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFBEBEBE)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFBEBEBE)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => content = val),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      // Nook Picker Dialog
      floatingActionButton: showNookPicker
          ? FloatingActionButton(
              onPressed: () => setState(() => showNookPicker = false),
              child: null,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      bottomSheet: showNookPicker
          ? Container(
              height: 400,
              color: Colors.grey[900],
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Select a Nook",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: nooks.length,
                      itemBuilder: (context, index) {
                        final nook = nooks[index];
                        final isSelected = selectedNook == nook;
                        return Card(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.grey[850],
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              color: Colors.blueGrey,
                            ),
                            title: Text(
                              nook['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              nook['description']!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () => pickNook(nook),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBEBEBE)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 6;
    const dashSpace = 4;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(8),
        ),
      );

    double distance = 0.0;
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
