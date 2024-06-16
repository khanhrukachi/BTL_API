import 'package:facebook_clone/features/posts/presentation/widgets/comment_text_field_widget.dart';
import 'package:facebook_clone/features/posts/presentation/widgets/comments_list_widget.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  final String postId;

  static const routeName = '/comments';

  // hello world

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          // Comments List
          CommentsListWidget(postId: postId),

          // Comment Text field
          CommentTextFieldWidget(
            postId: postId,
          ),
        ],
      ),
    );
  }
}
