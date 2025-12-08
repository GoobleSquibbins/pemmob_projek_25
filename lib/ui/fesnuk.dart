import 'package:flutter/material.dart';
import 'package:fesnuk/ui/create_thread_page.dart';

class FesnukPage extends StatelessWidget {
  const FesnukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ThreadPage(),
    );
  }
}

class ThreadPage extends StatefulWidget {
  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  // Dummy data for threads, simulating data from create_thread
  List<Map<String, dynamic>> threads = [
    {
      'nook': 'Nook 1',
      'title': 'Sample Thread Title 1',
      'content': 'This is the body content of the thread. It can be long text.',
      'images': ['https://via.placeholder.com/300'], // Placeholder image
      'reactions': {'up': 15, 'down': 2},
      'comments': ['Great post!', 'Thanks for sharing.'],
    },
    {
      'nook': 'Nook 2',
      'title': 'Another Thread Title',
      'content': 'More content here. Discussing various topics.',
      'images': [], // No image
      'reactions': {'up': 8, 'down': 1},
      'comments': ['Interesting!', 'I agree.'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          'Fesnuk',
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
      body: ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, index) {
          var thread = threads[index];
          return Card(
            color: const Color(0xFF3c3c3c),
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nook (like subreddit)
                  Text(
                    'n/${thread['nook']}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    thread['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Image if available
                  if (thread['images'].isNotEmpty)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(thread['images'][0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Content
                  Text(
                    thread['content'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Reaction menu
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            thread['reactions']['up']++;
                          });
                        },
                      ),
                      Text(
                        '${thread['reactions']['up']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.thumb_down, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            thread['reactions']['down']++;
                          });
                        },
                      ),
                      Text(
                        '${thread['reactions']['down']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.white),
                        onPressed: () {},
                      ),
                      Text(
                        '${thread['comments'].length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
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
