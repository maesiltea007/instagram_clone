import 'package:flutter/material.dart';
import './user.dart';

class Post {
  final String authorid; //userNickName
  final String caption;
  final List<String> mediaUrls; // 사진 여러 장
  final bool isVideo;
  final int likeCount;

  const Post({
    required this.authorid,
    required this.caption,
    required this.mediaUrls,
    this.isVideo = false,
    this.likeCount = 0,
  });
}