import 'package:instagram/models/post.dart';

final List<Post> dummyPosts = [
  //에스파 춤추는 릴스 포스트
  Post(
    authorid: '1',
    caption: 'Ouch!',
    mediaPaths: [
      'assets/videos/naruto_dance.mp4',
    ],
    isVideo: true,
    likeCount: 32,
  ),

  //카리나 얼굴 이미지 포스트
  Post(
    authorid: '2',
    caption: 'hello I am Karina',
    mediaPaths: [
      'assets/images/post_images/karinabluu_1.jpg',
      'assets/images/post_images/karinabluu_2.jpg',
      'assets/images/post_images/karinabluu_3.jpg',
      'assets/images/post_images/karinabluu_4.jpg',
      'assets/images/post_images/karinabluu_5.jpg',
      'assets/images/post_images/karinabluu_6.jpg',
      'assets/images/post_images/karinabluu_7.jpg',
      'assets/images/post_images/karinabluu_8.jpg',
    ],
    likeCount: 81,
  ),

  // 동영상 더미 나중에 추가해보기
];