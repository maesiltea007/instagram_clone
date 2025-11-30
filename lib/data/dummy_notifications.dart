import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/models/post.dart';

import '../models/notification_item.dart';

// 알림 리스트 (최신이 맨 위로 오도록 쓸 거라 정렬은 사용할 때)
final List<NotificationItem> notifications = [];

// unread 카운트 계산
int get unreadNotificationCount =>
    notifications.where((n) => !n.isRead).length;

// 댓글 알림 추가용 헬퍼
void addCommentNotification({
  required String fromUserId,
  required Post post,
  required String commentText,
}) {
  notifications.insert(
    0,
    NotificationItem(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      fromUserId: fromUserId,
      postId: post.id,
      text: commentText,
      createdAt: DateTime.now(),
      isRead: false,
    ),
  );
}

// 알림 전부 읽음 처리 (알림 페이지에서 호출)
void markAllNotificationsRead() {
  for (final n in notifications) {
    n.isRead = true;
  }
}