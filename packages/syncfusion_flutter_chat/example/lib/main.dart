import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_chat/chat.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late List<ChatMessage> _messages;

  @override
  void initState() {
    _messages = <ChatMessage>[
      ChatMessage(
        text: 'Hello, how can I help you today?',
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
