import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_chat/chat.dart';
import 'package:syncfusion_flutter_chat/assist_view.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Conversational UI Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ChatSample(),
                    ),
                  );
                },
                child: const Text('Chat Sample'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AssistViewSample(),
                  ),
                );
              },
              child: const Text('AI AssistView Sample'),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat Sample
class ChatSample extends StatefulWidget {
  const ChatSample({super.key});

  @override
  State<ChatSample> createState() => ChatSampleState();
}

class ChatSampleState extends State<ChatSample> {
  late List<ChatMessage> _messages;

  @override
  void initState() {
    _messages = <ChatMessage>[
      ChatMessage(
        text: 'Hi! How are you?',
        time: DateTime.now(),
        author: const ChatAuthor(
          id: '8ob3-b720-g9s6-25s8',
          name: 'Outgoing user name',
        ),
      ),
      ChatMessage(
        text: 'Fine, how about you?',
        time: DateTime.now(),
        author: const ChatAuthor(
          id: 'a2c4-56h8-9x01-2a3d',
          name: 'Incoming user name',
        ),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfChat(
          messages: _messages,
          outgoingUser: '8ob3-b720-g9s6-25s8',
          composer: const ChatComposer(
            decoration: InputDecoration(
              hintText: 'Type a message',
            ),
          ),
          actionButton: ChatActionButton(
            onPressed: (String newMessage) {
              setState(() {
                _messages.add(ChatMessage(
                  text: newMessage,
                  time: DateTime.now(),
                  author: const ChatAuthor(
                    id: '8ob3-b720-g9s6-25s8',
                    name: 'Outgoing user name',
                  ),
                ));
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}

// AssistView Sample
class AssistViewSample extends StatefulWidget {
  const AssistViewSample({super.key});

  @override
  State<AssistViewSample> createState() => AssistViewSampleState();
}

class AssistViewSampleState extends State<AssistViewSample> {
  late List<AssistMessage> _messages;

  void _generativeResponse(String data) async {
    final String response = await _getAIResponse(data);
    setState(() {
      _messages.add(AssistMessage.response(data: response));
    });
  }

  Future<String> _getAIResponse(String data) async {
    String response = '';
    // Connect with your preferred AI to generate a response to the request.
    return response;
  }

  @override
  void initState() {
    _messages = <AssistMessage>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter AI AssistView'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfAIAssistView(
          messages: _messages,
          composer: const AssistComposer(
            decoration: InputDecoration(
              hintText: 'Type a message',
            ),
          ),
          actionButton: AssistActionButton(
            onPressed: (String data) {
              setState(() {
                _messages.add(AssistMessage.request(data: data));
                _generativeResponse(data);
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }
}
