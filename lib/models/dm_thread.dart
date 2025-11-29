import 'package:flutter/material.dart';

class DmThread {
  final String threadId;
  final String peerUserId;      // 상대 유저 ID
  String lastMessageText;        // 리스트에 보여줄 마지막 메시지
  DateTime lastMessageTime;      // 마지막 메시지 시간
  bool isSeen;

  DmThread({
    required this.threadId,
    required this.peerUserId,
    required this.lastMessageText,
    required this.lastMessageTime,
    this.isSeen = true,
  });
}