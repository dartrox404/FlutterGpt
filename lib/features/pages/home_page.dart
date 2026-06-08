import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gpt/core/const/app_sizes.dart';
import 'package:flutter_gpt/core/extensions/app_extensions.dart';
import 'package:flutter_gpt/data/provider/api_provider.dart';
import 'package:flutter_gpt/data/provider/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(chatProvider);
    final typing = ref.watch(typingProvider);
    final data = ref.read(chatProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.color.secondary,
        title: Text(
          'BubbleChat Ai',
          style: context.text.titleLarge?.copyWith(fontFamily: 'poppins'),
        ),
      ),
      backgroundColor: context.color.secondary,
      body: SafeArea(
        child: DashChat(
          scrollToBottomOptions: ScrollToBottomOptions(disabled: true),
          typingUsers: typing ? [data.aiuser] : [],
          messageOptions: MessageOptions(
            showOtherUsersName: true,
            currentUserContainerColor: context.color.primary,
            containerColor: context.color.secondary,
            messageTextBuilder: (message, previousMessage, nextMessage) {
              final isai = message.user.id == "1";
              if (isai) {
                return GptMarkdown(
                  message.text,
                  style: context.text.bodyMedium?.copyWith(
                    fontFamily: 'poppins',
                    color: context.color.onPrimary,
                  ),
                );
              }
              return Text(
                message.text,
                style: context.text.bodyMedium?.copyWith(
                  fontFamily: 'poppins',
                  color: context.color.secondary,
                ),
              );
            },
          ),
          inputOptions: InputOptions(
            sendButtonBuilder: (send) {
              return IconButton(
                onPressed: send,
                icon: Icon(Iconsax.send1, color: context.color.onPrimary),
              );
            },
            inputTextDirection: TextDirection.ltr,
            inputDecoration: InputDecoration(
              counterStyle: context.text.bodyMedium?.copyWith(
                fontFamily: 'poppins',
                color: context.color.onPrimary,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: context.color.primary),
                borderRadius: BorderRadius.circular(AppSizes.kradiusXl),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: context.color.onPrimary),
                borderRadius: BorderRadius.circular(AppSizes.kradiusXl),
              ),
              hintText: "What's in your mind..?",
            ),
            alwaysShowSend: true,
            textInputAction: TextInputAction.send,
            inputTextStyle: context.text.bodyMedium?.copyWith(
              fontFamily: 'poppins',
              color: context.color.onPrimary,
            ),
          ),
          currentUser: data.cuurentuser,
          onSend: (message) {
            data.gethchat(message);
          },
          messages: message,
        ),
      ),
    );
  }
}
