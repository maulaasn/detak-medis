import 'package:flutter/material.dart';
import 'package:detak_medis/views/chatbot.dart';
import 'package:detak_medis/data/api/chatbot/chat_api.dart';

class ChatbotModel {
  final Function(ChatMessage message) onMessageReceived;
  final ChatUser _aiUser = ChatUser(id: 'ai', name: 'Asisten AI');

  ChatbotModel({required this.onMessageReceived});

  Future<void> sendMessage(String userMessageText) async {
    try {
      debugPrint("Sending message: $userMessageText");
      
      // memanggilAPI dengan hanya pesan user saja
      final responseData = await ChatApi.sendMessage(userMessageText);
      
      debugPrint("Received response: $responseData");
      debugPrint("Response type: ${responseData.runtimeType}");

      //  mengambil respons
      String aiResponseText = '';
      
      if (responseData is Map<String, dynamic>) {
        //  key response
        aiResponseText = responseData['answer']?.toString() ??
                        '';
        
        // Jika masih kosong, ambil semua nilai dari map
        if (aiResponseText.isEmpty) {
          aiResponseText = responseData.values.first?.toString() ?? '';
        }
      } else if (responseData is String) {
        aiResponseText = responseData;
      } else {
        aiResponseText = responseData.toString();
      }

      debugPrint("Extracted AI response: $aiResponseText");

      if (aiResponseText.isEmpty || aiResponseText == 'null') {
        throw Exception("AI response is empty or null");
      }

      final aiMessage = ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}-ai',
        text: aiResponseText,
        user: _aiUser,
        createdAt: DateTime.now(),
      );

      onMessageReceived(aiMessage);
      
    } catch (e) {
      debugPrint("Error in ChatbotModel.sendMessage: $e");
      debugPrint("Error type: ${e.runtimeType}");

      final errorMessage = ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}-error',
        text: "Maaf, terjadi kesalahan saat berkomunikasi dengan AI: ${e.toString()}",
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      onMessageReceived(errorMessage);
    }
  }
}