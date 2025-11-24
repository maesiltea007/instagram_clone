import 'package:instagram/models/post.dart';

final List<Post> dummyPosts = [
  Post(
    username: 'Sans',
    caption: 'Wa Sans!!!',
    mediaUrls: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKNglWJZDTrJ0lMThJWI6f3bPswwr6MGyjew&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYFAqFf0YwaLReYJ6lbs3Tcku7QWj1oGNpyQ&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEno9vDnCWJhQiWW3Hu3kuM-GJzc7UAnQ8XA&s',
    ],
    likeCount: 32,
  ),

  Post(
    username: 'stevejobs',
    caption: 'Stay hungry, Stay foolish',
    mediaUrls: [
      'https://igotoffer.com/apple/wp-content/uploads/2016/06/iphone-1-bill-gates-600x548.jpg',
    ],
    likeCount: 81,
  ),

  // 동영상 더미 나중에 추가해보기
];