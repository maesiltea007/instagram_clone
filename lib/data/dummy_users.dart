import '../models/user.dart';

// 로그인된 유저(현재 사용자)
User currentUser = user3;

//유저 매핑
final Map<String, User> usersById = {
  '1': user1,
  '2': user2,
  '3': user3,

};

//유저 더미 데이터
const User user1 = User(
  id: '1',
  userNickName: 'sans',
  userName: 'Sans',
  profileImageUrl:
  'https://external-preview.redd.it/Lg9NZJii_EtHF-vra0EjZcD3DzNsp1CFr7ZFeL-2Osk.jpg?width=640&crop=smart&auto=webp&s=1b3f862bacc18c76908feaef99667280e5ee8c80',
  bio: 'Wa! Sans! Do you know!',
  followerCount: 1200,
  followingCount: 10,
);

const User user2 = User(
  id: '2',
  userNickName: 'steve_jobs',
  userName: 'Steve Jobs',
  profileImageUrl:
  'https://upload.wikimedia.org/wikipedia/en/e/e4/Steve_Jobs_by_Walter_Isaacson.jpg',
  bio: 'think different',
  followerCount: 1000000,
  followingCount: 1,
);

const User user3 = User(
  id: '3',
  userNickName: 'link',
  userName: 'Link',
  profileImageUrl:
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqRPB_xF0L66JBQlXlQj51aQxz5B1pQb_JFA&s',
  bio: 'I am the last hope of the kingdom',
  followerCount: 100,
  followingCount: 100,
);