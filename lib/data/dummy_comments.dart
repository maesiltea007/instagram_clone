import '../models/comment.dart';
import 'dart:async';

final Map<String, List<Comment>> commentsByPostId = {

  //춤추는 릴스
  '1': [
    Comment(
      id: 'c11',
      postid: '1',
      authorId: '7',
      text: 'face is too close, but still beutiful LOL beutiful',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ],

  //카리나 얼굴 사진들
  '2': [
    Comment(
      id: 'c21',
      postid: '2',
      authorId: '8',
      text: 'jimin older sister!!',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ],

  '6': [
    Comment(
      id: 'c61',
      postid: '6',
      authorId: '9',
      text: 'lovely',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ],

};


// 10초 뒤 자동 댓글 추가
void scheduleAutoCommentForPost(String postId) {
  Future.delayed(const Duration(seconds: 10), () {
    final current = commentsByPostId[postId] ?? <Comment>[];
    final alreadyExists =
    current.any((c) => c.authorId == '10');

    if (alreadyExists) return;

    final newComment = Comment(
      id: 'auto_${DateTime.now().millisecondsSinceEpoch}',
      postid: postId,
      authorId: '10',
      text: 'so cute!!',
      createdAt: DateTime.now(),
    );

    commentsByPostId[postId] = [...current, newComment];
  });
}