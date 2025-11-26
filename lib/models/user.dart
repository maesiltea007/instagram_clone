class User {
  final String id;
  final String userNickName;   // @계정명
  final String userName;       // 실제이름
  final String profileImagePath;
  final String bio;
  final int followerCount;
  final int followingCount;

  const User({
    required this.id,
    required this.userNickName,
    required this.userName,
    required this.profileImagePath,
    this.bio = '',
    this.followerCount = 0,
    this.followingCount = 0,
  });
}