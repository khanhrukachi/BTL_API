import 'package:facebook_clone/features/posts/presentation/widgets/post_Image_video_view_widget.dart';
import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/features/chat/models/message.dart';

class MessageContentsWidget extends StatelessWidget {
  const MessageContentsWidget({
    super.key,
    required this.message,
    this.isSentMessage = false,
  });

  final Message message;
  final bool isSentMessage;

  @override
  Widget build(BuildContext context) {
    if (message.messageType == 'text') {
      return Text(
        message.message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: isSentMessage ? AppColors.whiteColor : AppColors.blackColor,
        ),
      );
    } else {
      return PostImageVideoViewWidget(
        fileUrl: message.message,
        fileType: message.messageType,
      );
    }
  }
}
