import 'package:flutter/foundation.dart';

class CommentsProvider extends ChangeNotifier {
  List<String> comments = [];

  void addComment(String comment) {
    comments.add(comment);
    notifyListeners();
  }
}