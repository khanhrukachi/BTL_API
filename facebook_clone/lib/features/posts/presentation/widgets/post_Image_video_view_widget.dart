import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'network_video_view_widget.dart';

class PostImageVideoViewWidget extends StatelessWidget {
  const PostImageVideoViewWidget({
    Key? key,
    required this.fileType,
    required this.fileUrl,
  }) : super(key: key);

  final String fileType;
  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    if (fileType == 'image') {
      return CachedNetworkImage(
        imageUrl: fileUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return NetworkVideoViewWidget(
        videoUrl: fileUrl,
      );
    }
  }
}
