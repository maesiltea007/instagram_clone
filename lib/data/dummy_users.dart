import '../models/user.dart';

//유저 매핑
final Map<String, User> users = {
  'sans': sans,
  'steve_jobs': steve_jobs,
};

const User sans = User(
  id: '1',
  userNickName: 'sans',
  userName: 'Sans',
  profileImageUrl:
  'https://external-preview.redd.it/Lg9NZJii_EtHF-vra0EjZcD3DzNsp1CFr7ZFeL-2Osk.jpg?width=640&crop=smart&auto=webp&s=1b3f862bacc18c76908feaef99667280e5ee8c80',
  followerCount: 1200,
  followingCount: 10,
);

const User steve_jobs = User(
  id: '2',
  userNickName: 'steve_jobs',
  userName: 'Steve Jobs',
  profileImageUrl:
  'https://upload.wikimedia.org/wikipedia/en/e/e4/Steve_Jobs_by_Walter_Isaacson.jpg',
  followerCount: 1000000,
  followingCount: 1,
);