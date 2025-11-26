import '../models/user.dart';

// 로그인된 유저(현재 사용자)
User currentUser = user0;

//유저 매핑
final Map<String, User> usersById = {
  '0': user0, //로그인한 계정
  '1': user1, //에스파
  '2': user2, //카리나
  '3': user3, //킹샷모바일
  '4': user4, //악뮤수현
  '5': user5, //호텔스닷컴
  '6': user6, //윈터
};

//유저 더미 데이터

//본인
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

//에스파
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

//카리나
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

//킹샷모바일
const User user3 = User(
  id: '3',
  userNickName: 'kingshot_mobile',
  userName: 'kingshot_mobile',
  profileImagePath:
  'assets/images/other_images/kingshot_mobile_profile.jpg',
  bio: '',
  followerCount: 1000000,
  followingCount: 1,
);

//악뮤 수현
const User user4 = User(
  id: '4',
  userNickName: 'akmu_suhyun',
  userName: 'suhyun',
  profileImagePath:
  'assets/images/other_images/akmu_suhyun_profile.jpg',
  bio: '',
  followerCount: 1000000,
  followingCount: 1,
);

//호텔스 닷컴 광고계정
const User user5 = User(
  id: '5',
  userNickName: 'hotelsdotcom',
  userName: 'hotel',
  profileImagePath:
  'assets/images/other_images/hotelsdotcom_logo.jpg',
  bio: '',
  followerCount: 100,
  followingCount: 1,
);

//윈터 계정
const User user6 = User(
  id: '5',
  userNickName: 'imwinter',
  userName: 'winter',
  profileImagePath:
  'assets/images/other_images/winter_profile.jpg',
  bio: '',
  followerCount: 1000000,
  followingCount: 1,
);
