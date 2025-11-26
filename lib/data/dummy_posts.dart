import 'package:instagram/models/post.dart';

final List<Post> dummyPosts = [
  //에스파 춤추는 릴스 포스트
  Post(
    id: '1',
    authorid: '1',
    caption: 'Ouch!',
    mediaPaths: [
      'assets/videos/naruto_dance.mp4',
    ],
    isVideo: true,
    likeCount: 90000,
    createdAt: DateTime(2025, 11, 26),
  ),

  //킹샷모바일 광고
  Post(
    id: '3',
    authorid: '3',
    caption: 'defeat and be number 1!!',
    mediaPaths: [
      'assets/videos/kingshot_ad.mp4',
    ],
    isVideo: true,
    likeCount: 3120,
    createdAt: DateTime(2025, 11, 5),
  ),

  //카리나 얼굴 이미지 포스트
  Post(
    id: '2',
    authorid: '2',
    caption: 'prada',
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
    likeCount: 100000,
    createdAt: DateTime(2025, 11, 20),
  ),

  //악뮤 수현 순례길 포스트
  Post(
    id: '4',
    authorid: '4',
    caption: 'my second sunrye road\nsun, wind, friends, I love it',
    mediaPaths: [
      'assets/images/post_images/akmu_suhyun_1.jpg',
      'assets/images/post_images/akmu_suhyun_2.jpg',
    ],
    likeCount: 100000,
    createdAt: DateTime(2025, 11, 20),
  ),

  //호텔스닷컴 광고
  Post(
    id: '5',
    authorid: '5',
    caption: 'hotelsdotcom advertisement\nhotel good price cheap',
    mediaPaths: [
      'assets/images/post_images/hotelsdotcom.jpg',
    ],
    likeCount: 777,
    createdAt: DateTime(2025, 10, 20),
  ),

  //윈터 얼굴 게시물
  Post(
    id: '6',
    authorid: '6',
    caption: '',
    mediaPaths: [
      'assets/images/post_images/winter_1.jpg',
      'assets/images/post_images/winter_2.jpg',
      'assets/images/post_images/winter_3.jpg',
      'assets/images/post_images/winter_4.jpg',
    ],
    likeCount: 77777,
    createdAt: DateTime(2025, 10, 20),
  ),
];