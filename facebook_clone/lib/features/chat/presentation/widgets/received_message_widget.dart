import 'package:facebook_clone/core/screens/error_screen.dart';
import 'package:facebook_clone/core/screens/loader.dart';
import 'package:facebook_clone/features/auth/providers/get_user_info_by_id_provider.dart';
import 'package:facebook_clone/features/chat/presentation/widgets/message_contents_widget.dart';
import 'package:facebook_clone/features/posts/presentation/widgets/round_profile_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/constants/app_colors.dart';
import '/features/chat/models/message.dart';

class ReceivedMessageWidget extends ConsumerWidget {
  final Message message;

  const ReceivedMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Nhận thông tin người dùng từ ChatUserInfoWidget
    final user = ref.watch(
      getUserInfoByIdProvider(message.senderId),
    );

    return user.when(
      data: (userData) {
        // Sử dụng ảnh đại diện của người dùng trong RoundProfileTileWidget
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              RoundProfileTileWidget(url: userData.profilePicUrl),
              const SizedBox(width: 15),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: const BoxDecoration(
                    color: AppColors.messengerGrey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: MessageContentsWidget(message: message),
                ),
              ),
            ],
          ),
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

