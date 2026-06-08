import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gpt/data/provider/api_provider.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

final chatProvider = StateNotifierProvider<ChatProvider, List<ChatMessage>>(
  (ref) => ChatProvider(ref),
);

class ChatProvider extends StateNotifier<List<ChatMessage>> {
  final Ref x;
  ChatProvider(this.x) : super([]);
  final ChatUser cuurentuser = ChatUser(
    id: '0',
    firstName: 'Arslan',
    profileImage: "assets/images/1.webp",
  );
  final ChatUser aiuser = ChatUser(
    id: '1',
    firstName: 'llama',
    profileImage: "assets/images/2.webp",
  );
  Future<void> gethchat(ChatMessage mess) async {
    state = [mess, ...state];
    x.read(typingProvider.notifier).state = true;
    try {
      final response = await x.read(apiProvider).aimessage(mess.text);
      final ChatMessage aimessage = ChatMessage(
        user: aiuser,
        createdAt: DateTime.now(),
        text: response,
      );
      state = [aimessage, ...state];
    } catch (e) {
      final ChatMessage aierrormessage = ChatMessage(
        user: aiuser,
        createdAt: DateTime.now(),
        text: e.toString(),
      );
      state = [aierrormessage, ...state];
    } finally {
      x.read(typingProvider.notifier).state = false;
    }
  }
}
