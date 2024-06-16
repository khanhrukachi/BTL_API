import 'package:facebook_clone/core/screens/error_screen.dart';
import 'package:facebook_clone/core/screens/loader.dart';
import 'package:facebook_clone/features/chat/presentation/widgets/chat_tile_widget.dart';
import 'package:facebook_clone/features/chat/providers/get_all_chats_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsListWidget extends ConsumerWidget {
  const ChatsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsList = ref.watch(getAllChatsProvider);
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return chatsList.when(
      data: (chats) {
        if (chats.isEmpty) {
          return const Center(
            child: Text('No chats available'),
          );
        }

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats.elementAt(index);
            final userId = chat.members.firstWhere(
                  (userId) => userId != myUid,
              orElse: () => 'unknown', // Provide a fallback in case all members are myUid
            );

            // Check if userId is valid
            if (userId == 'unknown') {
              // Skip rendering this chat if userId is not valid
              return const SizedBox.shrink();
            }

            return ChatTileWidget(
              userId: userId,
              lastMessage: chat.lastMessage,
              lastMessageTs: chat.lastMessageTs,
              chatroomId: chat.chatroomId,
            );
          },
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return const Loader();
      },
    );
  }
}
