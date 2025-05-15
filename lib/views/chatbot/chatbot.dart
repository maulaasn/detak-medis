import 'package:detak_medis/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _controller = ChatMessagesController();
  final _currentUser = ChatUser(id: 'user', firstName: 'User');
  final _aiUser = ChatUser(id: 'ai', firstName: 'AI Assistant');
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'AI Chat',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: wMainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AiChatWidget(
            // Required parameters
            currentUser: _currentUser,
            aiUser: _aiUser,
            controller: _controller,
            onSendMessage: _handleSendMessage,

            // Optional parameters
            messages: [],
            messageOptions: MessageOptions(
              // userBubbleColor: wMainColor,
              // aiBubbleColor: Colors.grey.shade100,
              // userTextStyle: TextStyle(color: Colors.white),
              // aiTextStyle: TextStyle(color: Colors.black87),
            ),

            inputOptions: InputOptions.glassmorphic(
              colors: [
                Colors.blue.withOpacity(0.2),
                Colors.lightGreenAccent.withOpacity(0.2),
              ],
              borderRadius: 24.0,
              blurStrength: 10.0,
              hintText: 'Ask me anything...',
              textColor: blackTextStyle.color,
            ),
            readOnly: false, // Allows the user to send messages

            exampleQuestions: [
              ExampleQuestion(question: "What can you help me with?"),
              ExampleQuestion(question: "Tell me about your features"),
            ],

            persistentExampleQuestions:
                true, // Keep example questions visible after welcome
            enableAnimation: true, // Enable message animations
            enableMarkdownStreaming: true, // Enable streaming text
            streamingDuration: Duration(milliseconds: 30), // Stream speed

            welcomeMessageConfig: WelcomeMessageConfig(
              title: 'Welcome to Heart Assistant',
              questionsSectionTitle: 'Try asking me:',
            ),

            loadingConfig: LoadingConfig(
              isLoading: _isLoading,
              showCenteredIndicator:
                  true, // Show loading indicator in the center
            ),

            paginationConfig: PaginationConfig(
              enabled: true,
              reverseOrder: true, // Newest messages at bottom
            ),
            maxWidth: 800, // Maximum width of the chat area
            padding: EdgeInsets.all(16), // Overall padding for the chat widget
          ),
          // Camera Icon Floating Button (di pojok kanan bawah input)
          Positioned(
            bottom: 70,
            right: 12,
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.grey[800]),
                onPressed: () {
                  // TODO: Implement camera action
                  print("Camera button tapped");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);

    try {
      // Simulating AI response after sending a message
      await Future.delayed(const Duration(seconds: 1));

      // Add AI response to the chat
      _controller.addMessage(
        ChatMessage(
          text: "This is a response to: ${message.text}",
          user: _aiUser,
          createdAt: DateTime.now(),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
