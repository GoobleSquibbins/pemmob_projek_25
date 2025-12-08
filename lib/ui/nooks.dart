import 'package:flutter/material.dart';
import 'package:fesnuk/ui/create_thread_page.dart';

class NooksPage extends StatelessWidget {
  const NooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> nooks = [
      {"name": "Nook 1", "description": "Description 1", "imageUrl": ""},
      {"name": "Nook 2", "description": "Description 2", "imageUrl": ""},
      {"name": "Nook 3", "description": "Description 3", "imageUrl": ""},
      {"name": "Nook 4", "description": "Description 4", "imageUrl": ""},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          'Nooks',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateThreadPage()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: nooks.length,
        itemBuilder: (context, index) {
          var nook = nooks[index];
          return Card(
            color: const Color(0xFF3c3c3c),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nook['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nook['description']!,
                    style: const TextStyle(
                      color: Color(0xFFC7C7C7),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
