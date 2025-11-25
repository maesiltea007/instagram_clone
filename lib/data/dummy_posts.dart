import 'package:instagram/models/post.dart';

final List<Post> dummyPosts = [
  Post(
    authorid: '1',
    caption: 'Wa Sans!!!',
    mediaPaths: [
      'assets/images/sans_in_castle.jpg',
      'assets/images/sleeping_sans.jpg',
      'assets/images/smile_sans.jpg',
    ],
    likeCount: 32,
  ),

  Post(
    authorid: '2',
    caption: 'Stay hungry, Stay foolish',
    mediaPaths: [
      'assets/images/iphone_on_hand.jpg',
    ],
    likeCount: 81,
  ),

  // 동영상 더미 나중에 추가해보기
];