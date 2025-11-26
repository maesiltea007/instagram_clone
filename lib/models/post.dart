import 'package:flutter/material.dart';
import './user.dart';

class Post {
  final String authorid; //userNickName
  final String caption;
  final List<String> mediaPaths; // 사진 여러 장
  final bool isVideo;
  final int likeCount;
  final DateTime createdAt;

  const Post({
    required this.authorid,
    required this.caption,
    required this.mediaPaths,
    this.isVideo = false,
    this.likeCount = 0,
    required this.createdAt,
  });
}