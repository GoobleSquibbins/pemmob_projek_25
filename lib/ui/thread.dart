import 'package:flutter/material.dart';

class thread_page extends StatelessWidget {
  const thread_page({super.key});

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
    }
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
                        onPressed: () {
                          // Navigate to comments or expand
                        },
                      ),
                      Text(
                        '${thread['comments'].length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Comment column
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF262626),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBEBEBE)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: const TextStyle(color: Color(0xFFC7C7C7)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (value) {
                        setState(() {
                          thread['comments'].add(value);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display existing comments
                  ...thread['comments'].map<Widget>((comment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        comment,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
