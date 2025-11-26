import '../models/user.dart';

// 로그인된 유저(현재 사용자)
User currentUser = user0;

//유저 매핑
final Map<String, User> usersById = {
  '0': user0,
  '1': user1,
  '2': user2,

};

//유저 더미 데이터
const User user0 = User(
  id: '0',
  userNickName: 'ta_junhyuk',
  userName: 'puang',
  profileImagePath:
  'assets/images/other_images/puang_profile_image.jpg',
  bio: 'I will be the god of flutter',
  followerCount: 1200,
  followingCount: 10,
);

const User user1 = User(
  id: '1',
  userNickName: 'aespa_official',
  userName: 'Aespa',
  profileImagePath:
  'assets/images/other_images/aespa_logo.jpg',
  bio: 'Wa! Sans! Do you know!',
  followerCount: 1200,
  followingCount: 10,
);

const User user2 = User(
  id: '2',
  userNickName: 'katarinabluu',
  userName: 'Karina',
  profileImagePath:
  'assets/images/other_images/karina_profile.jpg',
  bio: 'hello my name is karina. how are you.',
  followerCount: 1000000,
  followingCount: 1,
);