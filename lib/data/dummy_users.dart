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
  '7': user7, //춤추는 영상에 댓글 다는 계정
  '8': user8, //카리나에 댓글 다는 계정
  '9': user9, //윈터에 댓글 다는 계정
  '10': user10, //햇반
  '11': user11, //준혁
  '12': user12, //닝닝 - 내가 팔로잉 할 예정인 계정

  //내가 팔로잉 하고 있던 계정들
  '13': user13,
  '14': user14,
  '15': user15,
  '16': user16,
  '17': user17,

  //윈터가 팔로잉하고 있는 계정
  '50':user50, //지젤
};


//팔로잉 매핑
final Map<String, List<String>> followingByUserId = {
  '0': ['13', '14', '15', '16', '17', '1', '2', '12', '50'],
  '6': ['1', '2', '12', '50'],
};

// 헬퍼 함수
List<User> getFollowingUsers(String userId) {
  final ids = followingByUserId[userId] ?? [];
  return ids
      .map((id) => usersById[id])
      .where((u) => u != null)
      .cast<User>()
      .toList();
}

//유저 더미 데이터

//본인
User user0 = User(
  id: '0',
  userNickName: 'ta_junhyuk',
  userName: 'puang',
  profileImagePath:
  'assets/images/profile_images/puang_profile_image.jpg',
  bio: 'I will be the god of flutter',
  followerCount: 10,
  followingCount: 9,
);

//에스파
User user1 = User(
  id: '1',
  userNickName: 'aespa_official',
  userName: 'Aespa',
  profileImagePath:
  'assets/images/profile_images/aespa_logo.jpg',
  bio: 'Wa! Sans! Do you know!',
  followerCount: 1200,
  followingCount: 10,
);

//카리나
User user2 = User(
  id: '2',
  userNickName: 'katarinabluu',
  userName: 'Karina',
  profileImagePath:
  'assets/images/profile_images/karina_profile.jpg',
  bio: 'hello my name is karina. how are you.',
  followerCount: 1000000,
  followingCount: 1,
);

//킹샷모바일
User user3 = User(
  id: '3',
  userNickName: 'kingshot_mobile',
  userName: 'kingshot_mobile',
  profileImagePath:
  'assets/images/profile_images/kingshot_mobile_profile.jpg',
  bio: '',
  followerCount: 1000000,
  followingCount: 1,
);

//악뮤 수현
User user4 = User(
  id: '4',
  userNickName: 'akmu_suhyun',
  userName: 'suhyun',
  profileImagePath:
  'assets/images/profile_images/akmu_suhyun_profile.jpg',
  bio: '',
  followerCount: 1000000,
  followingCount: 1,
);

//호텔스 닷컴 광고계정
User user5 = User(
  id: '5',
  userNickName: 'hotelsdotcom',
  userName: 'hotel',
  profileImagePath:
  'assets/images/profile_images/hotelsdotcom_logo.jpg',
  bio: '',
  followerCount: 100,
  followingCount: 1,
);

//윈터 계정
User user6 = User(
  id: '6',
  userNickName: 'imwinter',
  userName: 'winter',
  profileImagePath:
  'assets/images/profile_images/winter_profile.jpg',
  bio: '',
  followerCount: 1000000,
  followingCount: 4,
);

//춤추는 영상에 댓글 다는 계정
User user7 = User(
  id: '7',
  userNickName: 'aespa_fan',
  userName: 'comment',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

//카리나 사진에 댓글 다는 계정
User user8 = User(
  id: '8',
  userNickName: 'karina_fan',
  userName: 'comment',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

//윈터 사진에 댓글 다는 계정
User user9 = User(
  id: '9',
  userNickName: 'winter_fan',
  userName: 'comment',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

//내 게시물에 댓글 다는 계정, 나랑 DM 하는 계정
User user10 = User(
  id: '10',
  userNickName: 'haetbaaaan',
  userName: 'shin',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

//나랑 DM하는 계정
User user11 = User(
  id: '11',
  userNickName: 'junhyuk_choi',
  userName: 'choi',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

//닝닝
User user12 = User(
  id: '12',
  userNickName: 'imnotningning',
  userName: 'ningning',
  profileImagePath:
  'assets/images/profile_images/ningning_profile_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);



//내가 팔로잉하고 있는 계정들
User user13 = User(
  id: '13',
  userNickName: 'friend13',
  userName: 'friend13',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

User user14 = User(
  id: '14',
  userNickName: 'friend14',
  userName: 'friend14',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

User user15 = User(
  id: '15',
  userNickName: 'friend15',
  userName: 'friend15',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

User user16 = User(
  id: '16',
  userNickName: 'friend16',
  userName: 'friend16',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);

User user17 = User(
  id: '17',
  userNickName: 'friend17',
  userName: 'friend17',
  profileImagePath:
  'assets/images/profile_images/default_user_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);



//윈터가 팔로잉하고 있는 계정
User user50 = User(
  id: '50',
  userNickName: 'aerichandesu',
  userName: 'GISELLE',
  profileImagePath:
  'assets/images/profile_images/giselle_profile_image.jpg',
  bio: '',
  followerCount: 1,
  followingCount: 1,
);







// ============ FOLLOW / UNFOLLOW HELPERS ============
void followUser(String myId, String targetId) {
  // 리스트 초기화
  followingByUserId[myId] ??= [];
  final list = followingByUserId[myId]!;
  // 이미 팔로잉 중이면 아무 것도 안 함
  if (!list.contains(targetId)) {
    list.add(targetId);
  }
  // followingCount 갱신
  final me = usersById[myId];
  if (me != null) {
    me.followingCount = list.length;
  }
}

void unfollowUser(String myId, String targetId) {
  final list = followingByUserId[myId];
  if (list == null) return;
  list.remove(targetId);
  final me = usersById[myId];
  if (me != null) {
    me.followingCount = list.length;
  }
}

// 내가 이 유저를 팔로잉 중인지 체크
bool isFollowing(String myId, String targetId) {
  final list = followingByUserId[myId];
  if (list == null) return false;
  return list.contains(targetId);
}