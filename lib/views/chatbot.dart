import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';
import 'package:detak_medis/data/models/chatbot/chatbot_model.dart';

/// Widget animasi "Typing..." saat AI membalas
class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<ChatBot>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Mengatur animasi berkedip
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(); // Ulang animasi
  }

  @override
  void dispose() {
    _animationController.dispose(); // Hentikan animasi saat dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        );
      },
    );
  }

  // Widget untuk titik animasi ketikan
  Widget _buildDot(int index) {
    double delay = index * 0.33;
    double opacity = 0.4;

    if (_animation.value > delay && _animation.value < delay + 0.33) {
      opacity = 1.0;
    }

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 100),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey[600],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Representasi pengguna (user/AI)
class ChatUser {
  final String id;
  final String name;

  ChatUser({required this.id, required this.name});
}

/// Representasi pesan chat
class ChatMessage {
  final String id;
  final String text;
  final ChatUser user;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.user,
    required this.createdAt,
  });
}

/// Halaman utama chatbot
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({
    super.key,
    required Future<Null> Function(String messageText) onSendMessageToModel,
  });

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _inputMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  final ChatUser _currentUser = ChatUser(id: 'user', name: 'You');
  final ChatUser _aiUser = ChatUser(id: 'ai', name: 'Detak Medis');

  late final ChatbotModel _chatbotModel;

  @override
  void initState() {
    super.initState();
    // Inisialisasi model chatbot dan callback untuk menerima pesan
    _chatbotModel = ChatbotModel(onMessageReceived: addMessageFromModel);
  }

  @override
  void dispose() {
    _inputMessageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Fungsi scroll ke bawah saat ada pesan baru
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Menangani pesan yang dikirim user
  Future<void> _handleUserMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newUserMessage = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}-user',
      text: text,
      user: _currentUser,
      createdAt: DateTime.now(),
    );

    setState(() {
      _messages.add(newUserMessage);
      _inputMessageController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      await _chatbotModel.sendMessage(text);
    } catch (e) {
      debugPrint("Error in _handleUserMessage: $e");
      _addAiMessage("Maaf, terjadi kesalahan: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  /// Tambahkan pesan dari AI
  void _addAiMessage(String text) {
    final aiMessage = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}-ai',
      text: text,
      user: _aiUser,
      createdAt: DateTime.now(),
    );
    setState(() {
      _messages.add(aiMessage);
    });
    _scrollToBottom();
  }

  /// Fungsi callback dari model untuk menambahkan pesan AI
  void addMessageFromModel(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  /// Fungsi untuk memformat teks dengan **bold** dan \n newline
  Widget _buildFormattedText(String text, {required bool isCurrentUser}) {
    List<TextSpan> spans = [];
    List<String> parts = text.split('**');

    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      List<String> lines = part.split('\\n');

      for (int j = 0; j < lines.length; j++) {
        if (lines[j].isNotEmpty) {
          spans.add(
            TextSpan(
              text: lines[j],
              style: TextStyle(
                color: isCurrentUser ? Colors.white : blackTextStyle.color,
                fontSize: 15,
                fontWeight: i % 2 == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }

        if (j < lines.length - 1) {
          spans.add(TextSpan(text: '\n'));
        }
      }
    }

    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Detak Medis Assistant',
          style: blackTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Tinggi garis
          child: Container(
            height: 1.0,
            color: Colors.grey.shade300, // Warna garis bawah
          ),
        ),
      ),
      body: Column(
        children: [
          // List chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  final message = _messages[index];
                  final isCurrentUser = message.user.id == _currentUser.id;
                  return Align(
                    alignment:
                        isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentUser ? wMainColor : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0),
                          bottomLeft:
                              isCurrentUser
                                  ? const Radius.circular(16.0)
                                  : Radius.zero,
                          bottomRight:
                              isCurrentUser
                                  ? Radius.zero
                                  : const Radius.circular(16.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormattedText(
                            message.text,
                            isCurrentUser: isCurrentUser,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${message.user.name} • ${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color:
                                  isCurrentUser
                                      ? Colors.white70
                                      : Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Loading typing indicator
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.circular(16.0),
                        ),
                      ),
                      child: const ChatBot(),
                    ),
                  );
                }
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputMessageController,
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan Anda...',
                      fillColor: Colors.grey[100],
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: wMainColor, width: 2.0),
                      ),
                    ),
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () =>
                              _handleUserMessage(_inputMessageController.text),
                  backgroundColor: wMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 0,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
